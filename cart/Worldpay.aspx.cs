using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Worldpay.Sdk;
using Worldpay.Sdk.Enums;
using Worldpay.Sdk.Models;
using Newtonsoft.Json;
using System.Configuration;

public partial class cart_Worldpay : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo
    {
        get;
        set;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            createOrder();
        }
    }

    private void createOrder()
    {
        var form = HttpContext.Current.Request.Form;
        var client = new WorldpayRestClient(ConfigurationManager.AppSettings["BaseUrl"], ConfigurationManager.AppSettings["ServiceKey"]);
        var orderType = OrderType.ECOM;

        var cardRequest = new CardRequest();
        cardRequest.cardNumber = form["number"];
        cardRequest.cvc = form["cvc"];
        cardRequest.name = form["name"];
        cardRequest.expiryMonth = Convert.ToInt32(form["exp-month"]);
        cardRequest.expiryYear = Convert.ToInt32(form["exp-year"]);
        cardRequest.type = form["cardType"];
        int? _amount = 0;
        var _currencyCode = "";
        Dictionary<string, string> custIdentifiers = new Dictionary<string, string>();

        try
        {           
            custIdentifiers = JsonConvert.DeserializeObject<Dictionary<string, string>>(form["customer-identifiers"]);
        }
        catch (Exception exc) { }

        try
        {
            if (!string.IsNullOrEmpty(Session["Cost"].ToString()))
            {
                double n;
                bool isNumeric = double.TryParse(Session["Cost"].ToString(), out n);
                _amount = isNumeric ? (int)(Convert.ToDecimal(Session["Cost"].ToString()) * 100) : -1;
            }
        }
        catch (Exception excAmount) { }

        try
        {
            _currencyCode = "GBP";
        }
        catch (Exception excCurrency) { }

        var billingAddress = new Address()
        {
            address1 = form["address1"],
            address2 = form["address2"],
            address3 = form["address3"],
            postalCode = form["postcode"],
            city = form["city"],
            telephoneNumber = form["telephone-number"],
            state = "",
            countryCode = "GB"
        };

        var deliveryAddress = new DeliveryAddress()
        {
            firstName = form["delivery-firstName"],
            lastName = form["delivery-lastName"],
            address1 = form["delivery-address1"],
            address2 = form["delivery-address2"],
            address3 = form["delivery-address3"],
            postalCode = form["delivery-postcode"],
            city = form["delivery-city"],
            telephoneNumber = form["delivery-telephone-number"],
            state = "",
            countryCode = ""
        };

        var is3DS = form["3ds"] == "on" ? true : false;
        ThreeDSecureInfo threeDSInfo = null;
        if (is3DS)
        {
            var httpRequest = HttpContext.Current.Request;
            threeDSInfo = new ThreeDSecureInfo()
            {
                shopperIpAddress = httpRequest.UserHostAddress,
                shopperSessionId = HttpContext.Current.Session.SessionID,
                shopperUserAgent = httpRequest.UserAgent,
                shopperAcceptHeader = String.Join(";", httpRequest.AcceptTypes)
            };
        }

        var request = new OrderRequest()
        {
            token = form["token"],
            orderDescription = "999parcel order",
            amount = _amount,
            currencyCode = _currencyCode,
            name = is3DS && Session["mode"].Equals("test") ? "3D" : form["name"],
            shopperEmailAddress = "shopper@email.com",
            statementNarrative = "Statement Narrative",
            billingAddress = billingAddress,
            deliveryAddress = deliveryAddress,
            threeDSecureInfo = is3DS ? threeDSInfo : new ThreeDSecureInfo(),
            is3DSOrder = is3DS,
            authorizeOnly = form["authorizeOnly"] == "on",
            orderType = orderType.ToString(),
            customerIdentifiers = custIdentifiers,
            customerOrderCode = form["customer-order-code"],
            orderCodePrefix = form["order-code-prefix"],
            orderCodeSuffix = form["order-code-suffix"]
        };

        var directOrder = true;

        if (directOrder)
        {
            request.shopperLanguageCode = "EN";
            request.reusable = form["chkReusable"] == "on";
            request.paymentMethod = new CardRequest()
            {
                name = form["name"],
                expiryMonth = Convert.ToInt32(form["exp-month"]),
                expiryYear = Convert.ToInt32(form["exp-year"]),
                cardNumber = form["number"],
                cvc = form["cvc"]
            };
        }

        if (!string.IsNullOrEmpty(form["settlement-currency"]))
        {
            request.settlementCurrency = form["settlement-currency"];
        }
        if (!string.IsNullOrEmpty(form["site-code"]))
        {
            request.siteCode = form["site-code"];
        }

        request.siteCode = "N/A";
        request.shopperLanguageCode = "EN";

        try
        {
            var response = client.GetOrderService().Create(request);
            if (response.paymentStatus == OrderStatus.SUCCESS)
            {
                IEnumerable<Order> orders = Session["Orders"] as IEnumerable<Order>;
                int total999PickupCount = int.Parse(Session["Total999PickupCount"].ToString());
                SendHelper.PayOrders(orders, total999PickupCount >= 3, total999PickupCount);      
                if (orders.All(o => (o.SuccessPaid ?? false) == false))
                {
                    client.GetOrderService().Refund(response.orderCode);
                    Session["Message"] = "发送订单失败，Worldpay已退款";
                    //Response.Redirect("cart.aspx");
                }
                repo.Context.SaveChanges();
                Response.Redirect("paid.aspx");
            }
            HandleSuccessResponse(response);

            SuccessPanel.Visible = true;
        }
        catch (WorldpayException exc)
        {
            msg.Text = exc.apiError.message;
        }
        catch (Exception exc)
        {
            throw new InvalidOperationException("Error sending request with token " + request.token, exc);
        }
    }
    private void HandleSuccessResponse(OrderResponse response)
    {
        if (response.paymentStatus == OrderStatus.PRE_AUTHORIZED && response.paymentResponse.type == OrderType.APM.ToString())
        {
            //HandleAPMResponse(response);
            return;
        }
        if (response.paymentStatus == OrderStatus.PRE_AUTHORIZED && response.is3DSOrder)
        {
            //Handle3DSResponse(response);
            return;
        }

        ResponseOrderCode.Text = response.orderCode;
        ResponseToken.Text = response.token;
        ResponsePaymentStatus.Text = response.paymentStatus.ToString();
        ResponseJson.Text = JsonConvert.SerializeObject(response);
    }
}