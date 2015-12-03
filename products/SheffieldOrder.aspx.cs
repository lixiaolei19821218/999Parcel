using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class products_SheffiledOrder : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    private SheffieldOrder sOrder;    

    public SheffieldOrder SheffieldOrder
    {
        get
        {
            return sOrder;
        }
    }

    public IEnumerable<Order> GetOrders()
    {
        return sOrder.Orders;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        sOrder = (SheffieldOrder)Session["SheffieldOrder"];
        if (sOrder == null)
        {
            Response.Redirect("/");
        }
    }

    protected void add2cart_Click(object sender, EventArgs e)
    {        
        foreach (Order order in sOrder.Orders)
        {
            order.SenderName = Request.Form.Get("billing_detail_name");
            order.SenderCity = Request.Form.Get("billing_detail_city");
            order.SenderPhone = Request.Form.Get("billing_detail_phone");
            order.SenderAddress1 = Request.Form.Get("billing_detail_street");
            order.SenderAddress2 = Request.Form.Get("billing_detail_street2");
            order.SenderAddress3 = Request.Form.Get("billing_detail_street3");
            order.SenderZipCode = Request.Form.Get("billing_detail_postcode");

            Recipient recipient = order.Recipients.ElementAt(0);
            recipient.Name = Request.Form.Get("addr-0-cn_name");
            recipient.City = Request.Form.Get("addr-0-cn_city");
            recipient.Address = Request.Form.Get("addr-0-cn_street");
            recipient.PhoneNumber = Request.Form.Get("addr-0-phone");
            recipient.ZipCode = Request.Form.Get("addr-0-postcode");

            DateTime date;
            if (DateTime.TryParse(Request["pickup_time_0"], out date))
            {
                order.PickupTime = date;
            }

            order.User = Membership.GetUser().UserName;
            order.OrderTime = DateTime.Now;
            //repo.Context.Orders.Add(order);            
        }

        sOrder.User = Membership.GetUser().UserName;

        if (sOrder.Id == 0)
        {
            repo.Context.SheffieldOrders.Add(sOrder);
        }
        repo.Context.SaveChanges();
        Response.Redirect("/cart/cart.aspx");
    }

    public decimal GetTotalPrice()
    {
        return sOrder.Orders.Sum(o => o.Cost.Value);
    }
}