using iTextSharp.text;
using iTextSharp.text.pdf;
using UKMAuthenticationServiceQA;
using SevenSeasAPIClient.YCShipmentService;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading;
using System.Timers;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;
//using UKMCollectionService;
using UKMConsignmentServiceQA;
using WMOrderService;
using System.Collections;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using ZXing;
using System.Drawing;
using ZXing.Common;
using System.Dynamic;

public partial class cart_Cart : System.Web.UI.Page
{
    private IEnumerable<Order> normalOrders;    
    private IEnumerable<SheffieldOrder> sheffieldOrders;
    private decimal balance;
    private decimal totalPrice;
    private string username;
    private aspnet_User apUser;
    private string lciFile;

    [Ninject.Inject]
    public IRepository repo
    {
        get;
        set;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        username = Membership.GetUser().UserName;
        apUser = repo.Context.aspnet_User.First(u => u.UserName == username);

        normalOrders = from o in repo.Orders where o.User == username && !(o.HasPaid ?? false) select o;
        //sheffieldOrders = from o in repo.Context.SheffieldOrders where o.User == username && !o.HasPaid select o;

        balance = apUser.Balance;
        totalPrice = normalOrders.Sum(o => o.Cost.Value);
        //totalPrice = normalOrders.Sum(o => o.Cost.Value) + sheffieldOrders.Sum(so => so.Orders.Sum(o => o.Cost.Value));

        //normalField.Visible = normalOrders == null || normalOrders.Count() != 0 ? true : false;
        //sheffieldField.Visible = sheffieldOrders == null || sheffieldOrders.Count() != 0 ? true : false;
    }

    public IEnumerable<Order> GetNoneSheffieldOrders()
    {               
        return normalOrders;
    }

    public IEnumerable<SheffieldOrder> GetSheffieldOrders()
    {
        //return new List<SheffieldOrder>();
        return sheffieldOrders;
    }

    public string GetOrderTip(Order order)
    {
        ServiceView sv = new ServiceView(order.Service);
        Thread.CurrentThread.CurrentCulture = new CultureInfo("en-gb");
        return string.Format("取件费：{0:c2}，加固费：{1:c2}，快递费：{2:c2}， 折扣：-{3:c2}", order.PickupPrice, order.ReinforcePrice, order.DeliverPrice, order.Discount);
    }

    public decimal GetAmount()
    {
        
        return balance;
    }

    public decimal GetTotalPrice()
    {       
        return totalPrice;
    }
    protected void ButtonEdit_Click(object sender, EventArgs e)
    {
        int id;
        if (int.TryParse((sender as Button).Attributes["data-id"], out id))
        {
            Order order = repo.Context.Orders.Find(id);

            Order orderCopy = new Order();
            orderCopy.IsValid = order.IsValid;
            orderCopy.HasPaid = order.HasPaid;
            orderCopy.OrderTime = order.OrderTime;
            orderCopy.PickupTime = order.PickupTime;
            orderCopy.SenderAddress1 = order.SenderAddress1;
            orderCopy.SenderAddress2 = order.SenderAddress2;
            orderCopy.SenderAddress3 = order.SenderAddress3;
            orderCopy.SenderCity = order.SenderCity;
            orderCopy.SenderName = order.SenderName;
            orderCopy.SenderPhone = order.SenderPhone;
            orderCopy.SenderZipCode = order.SenderZipCode;
            orderCopy.ServiceID = order.ServiceID;
            //orderCopy.Service = order.Service;
            orderCopy.User = order.User;
            orderCopy.Id = order.Id;
            orderCopy.ReinforceID = order.ReinforceID;

            foreach (Recipient r in order.Recipients)
            {
                Recipient rc = new Recipient();
                rc.Name = r.Name;
                rc.PhoneNumber = r.PhoneNumber;
                rc.ZipCode = r.ZipCode;
                rc.Address = r.Address;
                rc.City = r.City;
                rc.PyAddress = r.PyAddress;
                rc.PyCity = r.PyCity;
                rc.PyName = r.PyName;

                foreach (Package p in r.Packages)
                {
                    Package pc = new Package();
                    pc.Height = p.Height;
                    pc.Length = p.Length;
                    pc.Width = p.Width;
                    pc.Weight = p.Weight;
                    pc.TrackNumber = p.TrackNumber;
                    pc.Detail = p.Detail;
                    pc.Value = p.Value;
                    foreach (PackageItem item in p.PackageItems)
                    {
                        PackageItem ic = new PackageItem();
                        ic.Count = item.Count;
                        ic.Description = item.Description;
                        ic.NettoWeight = item.NettoWeight;
                        ic.TariffCode = item.TariffCode;
                        ic.Value = item.Value;
                        pc.PackageItems.Add(ic);
                    }
                    rc.Packages.Add(pc);
                }

                orderCopy.Recipients.Add(rc);
            }

            Session["Order"] = orderCopy;
            Response.Redirect("/products/product.aspx");
        }
    }

    protected void ButtonDel_Click(object sender, EventArgs e)
    {
        int id;
        if (int.TryParse((sender as Button).Attributes["data-id"], out id))
        {
            Order myOrder = repo.Orders.Where(o => o.Id == id).FirstOrDefault();
            if (myOrder != null)
            {
                foreach (Recipient r in myOrder.Recipients)
                {
                    foreach (Package p in r.Packages)
                    {
                        repo.Context.PackageItems.RemoveRange(p.PackageItems);
                    }
                    repo.Context.Packages.RemoveRange(r.Packages);
                }
                repo.Context.Recipients.RemoveRange(myOrder.Recipients);
                repo.Context.Orders.Remove(myOrder);

                repo.Context.SaveChanges();
            }
        }
        Response.Redirect(Request.Path);        
    }
    protected void ButtonSheffieldEdit_Click(object sender, EventArgs e)
    {
        int id;
        if (int.TryParse((sender as Button).Attributes["data-id"], out id))
        {
            SheffieldOrder myOrder = repo.SheffieldOrders.Where(o => o.Id == id).FirstOrDefault();
            Session["SheffieldOrder"] = myOrder;
        }
        Response.Redirect("/products/SheffieldOrder.aspx");       
    }
    protected void ButtonSheffieldDel_Click(object sender, EventArgs e)
    {
        int id;
        if (int.TryParse((sender as Button).Attributes["data-id"], out id))
        {
            SheffieldOrder myOrder = repo.SheffieldOrders.Where(o => o.Id == id).FirstOrDefault();
            if (myOrder != null)
            {
                foreach (Order o in myOrder.Orders)
                {
                    repo.Context.Packages.RemoveRange(o.Recipients.ElementAt(0).Packages);
                    repo.Context.Recipients.Remove(o.Recipients.ElementAt(0));
                }
                repo.Context.Orders.RemoveRange(myOrder.Orders);
                repo.Context.SheffieldOrders.Remove(myOrder);
                repo.Context.SaveChanges();
            }
        }
        Response.Redirect(Request.Path);
    }

    private void PayOrders(IEnumerable<Order> orders)
    {
        List<string> attachmentPaths = new List<string>();
        foreach (Order o in orders)
        {
            switch (o.Service.Name.Trim())
            {
                case "荷兰邮政 - 免费取件":
                case "荷兰邮政 - UKMail 取件":

                    break;
                case "Parcelforce Economy - 上门取件":
                    SendTo51Parcel(o, UKShipmentType.ParcelForceUK, ServiceProvider.ParcelForceEconomyPickup, attachmentPaths);
                    break;
                case "Parcelforce Priority - 上门取件":
                    SendTo51Parcel(o, UKShipmentType.ParcelForceUK, ServiceProvider.ParcelForcePriority, attachmentPaths);
                    break;
                case "Parcelforce Economy - 自送Depot":
                    SendTo51Parcel(o, UKShipmentType.Send2Warehouse, ServiceProvider.ParcelForceEconomyDropOff, attachmentPaths);
                    break;
                case "Parcelforce Economy - 自送邮局":
                    SendTo51Parcel(o, UKShipmentType.ParcelForceUK, ServiceProvider.ParcelForceEconomyDropOff, attachmentPaths);
                    break;
                case "Parcelforce Priority - 自送邮局":
                    SendTo51Parcel(o, UKShipmentType.ParcelForceUK, ServiceProvider.ParcelForcePriority, attachmentPaths);
                    break;
                case "Bpost - 诚信物流取件":
                    //SendBpostLciFile(o);
                    SendToBpost(o);
                    break;
                case "Bpost - UKMail 取件":
                    if (UKMailCollection(o))
                    {
                        SendToBpost(o);
                    }
                    break;
                case "杂物包税专线（100镑以内） - 自送仓库":
                case "杂物包税专线（100镑以内） - 诚信物流取件":
                case "杂物包税专线（200镑以内） - 自送仓库":
                case "杂物包税专线（200镑以内） - 诚信物流取件":
                    SendTo4PX(o);
                    break;
                case "奶粉包税专线 - 诚信物流取件":
                case "奶粉包税专线 - 自送仓库":
                    SendToBpost(o, "LGINTSTD");
                    break;
                default:
                    break;
            }

            #region 华盟
            /*
                foreach (Recipient r in o.Recipients)
                {
                    OrderServiceClient client = new OrderServiceClient();
                    int parcelCount = r.Packages.Count;
                    string[] purposeOfShipment = new string[parcelCount];
                    for (int i = 0; i < purposeOfShipment.Length; i++)
                    {
                        purposeOfShipment[i] = "Gift";
                    }

                    OrderResponse response = client.OrderPlace(
                        r.Packages.Select(p => p.Detail).ToArray(),
                        purposeOfShipment,
                        r.Packages.Select(p => (float)p.Height).ToArray(),
                        r.Packages.Select(p => (float)p.Length).ToArray(),
                        r.Packages.Select(p => (float)p.Width).ToArray(),
                        r.Packages.Select(p => (float)p.Weight).ToArray(),
                        r.Packages.Select(p => (float)p.Value).ToArray(),
                        parcelCount,
                        wmPassword,
                        wmUsername,
                        r.ZipCode,
                        r.Address,
                        r.City,
                        "Personal",
                        r.Name,
                        "China",
                        r.PhoneNumber,
                        r.Order.SenderAddress1 + " " + r.Order.SenderAddress2 + " " + r.Order.SenderAddress3,
                        r.Order.SenderCity,
                        "Personal",
                        r.Order.SenderName,
                        "UK",
                        r.Order.SenderPhone,//"B29 7sn",
                        r.Order.SenderZipCode,
                        wmService,
                        r.Order.PickupTime.ToString()
                        );

                    if (response.Errors == null)
                    {
                        //国际追踪号
                        string tracknumber = response.TrackNumber;
                        //WM的订单号，主订单号
                        string wm_leadernumber = response.LeaderOrderNumber;
                        //WM的包裹号，用逗号分隔
                        string wm_ordernumber = response.OrderNumber;
                        //返回的pdf信息，
                        LabelResponse labelResponse_leader = client.GetLabelByWMLeaderNumber(wmUsername, wmPassword, wm_leadernumber);
                        //订单合并成的一个pdf，输入为主订单号
                        if (labelResponse_leader.Errors == null)
                        {
                            byte[] byt = labelResponse_leader.Label;
                            string folderPath = AppDomain.CurrentDomain.BaseDirectory + "pdf\\" + Membership.GetUser().UserName;
                            if (!Directory.Exists(folderPath))
                            {
                                Directory.CreateDirectory(folderPath);
                            }
                            string attachment = folderPath + "\\" + wm_leadernumber + ".pdf";
                            File.WriteAllBytes(attachment, byt);
                           
                            r.WMLeaderNumber = wm_leadernumber;
                            r.WMLeaderPdf = wm_leadernumber + ".pdf"; 
                            string[] tracknumbers = tracknumber.Split(',');
                            for (int i = 0; i < r.Packages.Count; i++)
                            {
                                r.Packages.ElementAt(i).TrackNumber = tracknumbers[i];
                            }
                            r.SuccessPaid = true;
                            attachmentPaths.Add(attachment);
                        }
                        else
                        {
                            //错误保存在Errors里面
                            r.SuccessPaid = false;
                            StringBuilder errors = new StringBuilder();
                            foreach (string error in labelResponse_leader.Errors)
                            {
                                errors.Append(error + ";");
                            }

                            r.Errors = errors.ToString();
                        }

                        /*
                        //根据包裹号下载pdf
                        string[] packagenumbers = wm_ordernumber.Split(',');
                        LabelResponse labelResponse_package = client.GetLabelByPackgeNumber(username, password, packagenumbers[0]);
                        if (labelResponse_package.Errors == null)
                        {
                            byte[] byt = labelResponse_package.Label;
                            File.WriteAllBytes(AppDomain.CurrentDomain.BaseDirectory + "\\pdf\\" + packagenumbers[0] + ".pdf", byt);

                        }
                        else
                        {
                            //错误保存在Errors里面
                        }
                        //根据国际单号下载pdf
                        string[] tracknumbers = tracknumber.Split(',');
                        LabelResponse labelResponse_track = client.GetLabelByTrackNumber(username, password, tracknumbers[0]);
                        if (labelResponse_track.Errors == null)
                        {
                            byte[] byt = labelResponse_track.Label;
                            File.WriteAllBytes(AppDomain.CurrentDomain.BaseDirectory + "\\pdf\\" + tracknumbers[0] + ".pdf", byt);

                        }
                        else
                        {
                            //错误保存在Errors里面
                        }
                         


                    }
                    //如果出现错误
                    else
                    {
                        for (int i = 0; i < response.Errors.Length; i++)
                        {//错误列表
                            string error = response.Errors[i].ToString();
                        }
                        r.SuccessPaid = false;

                        StringBuilder errors = new StringBuilder();
                        foreach (string error in response.Errors)
                        {
                            errors.Append(error + ";");
                        }

                        r.Errors = errors.ToString();
                    }                    
                }
        */
            #endregion

            o.HasPaid = true;
        }
    }

    private void SendToBpost(Order order, string shipMethod = "LGINTBPMU")
    {
        foreach (Recipient recipient in order.Recipients)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
            sb.Append("<ImportRequest>");
            sb.Append("<Login>");
            sb.Append("<Username>999API</Username>");
            sb.Append("<Password>999API1234</Password>");
            sb.Append("</Login>");
            sb.Append("<Test>false</Test>");
            sb.Append("<ClientID>883</ClientID>");
            sb.AppendFormat("<Reference>{0}</Reference>", order.Id);
            sb.Append("<ShipTo>");
            sb.AppendFormat("<Name>{0}</Name>", recipient.PyName);
            sb.Append("<Attention></Attention>");
            sb.AppendFormat("<Address1>{0}</Address1>", recipient.PyAddress);
            sb.Append("<Address2></Address2>");
            sb.Append("<Address3></Address3>");
            sb.AppendFormat("<City>{0}</City>", recipient.PyCity);
            sb.Append("<State></State>");
            sb.AppendFormat("<PostalCode>{0}</PostalCode>", recipient.ZipCode);
            sb.Append("<Country>CN</Country>");
            sb.AppendFormat("<Phone>{0}</Phone>", recipient.PhoneNumber);
            sb.AppendFormat("<Email>{0}</Email>", recipient.Email);
            sb.AppendFormat("<ConsigneeTaxID>{0}</ConsigneeTaxID>", recipient.IDNumber);
            sb.Append("<Region>Landmark UK</Region>");
            sb.Append("<Residential>true</Residential>");
            sb.Append("</ShipTo>");
            sb.Append("<ShippingLane>");
            sb.Append("<OriginFacilityCode></OriginFacilityCode>");
            sb.Append("</ShippingLane>");
            sb.Append(string.Format("<ShipMethod>{0}</ShipMethod>", shipMethod));
            sb.Append("<ShipmentInsuranceFreight></ShipmentInsuranceFreight>");
            sb.Append("<ItemsCurrency>GBP</ItemsCurrency>");
            sb.Append("<ProduceLabel>true</ProduceLabel>");
            sb.Append("<LabelEncoding>LINKS</LabelEncoding>");/*
            sb.Append("<ShipOptions>");
            sb.Append("<Option>");
            sb.Append("<Name>dummy_option</Name>");
            sb.Append("<Value>true</Value>");
            sb.Append("</Option>");
            sb.Append("</ShipOptions>");*/
            sb.Append("<VendorInformation>");
            sb.Append("<VendorName>999 Parcel</VendorName>");
            sb.Append("<VendorAddress1>83 Fitzwilliam street</VendorAddress1>");
            sb.Append("<VendorAddress2></VendorAddress2>");
            sb.Append("<VendorCity>Sheffield</VendorCity>");
            sb.Append("<VendorState></VendorState>");
            sb.Append("<VendorPostalCode>S1 4JP</VendorPostalCode>");
            sb.Append("<VendorCountry>UK</VendorCountry>");
            sb.Append("</VendorInformation>");/*
            sb.Append("<AdditionalFields>");
            sb.Append("<Field1>Any type of data</Field1>");
            sb.Append("<Field2>Purchased with Credit Card</Field2>");
            sb.Append("<Field3>99000029327172321</Field3>");
            sb.Append("<Field4>123198012</Field4>");
            sb.Append("<Field5>Stored information</Field5>");
            sb.Append("</AdditionalFields>");
            sb.Append("<PickSlipAdditions>");
            sb.Append("<Charges>");
            sb.Append("<Charge>");
            sb.Append("<Description>Gift Card Code: DISCOUNTHOUND</Description>");
            sb.Append("<Value>-7.25</Value>");
            sb.Append("</Charge>");
            sb.Append("<Charge>");
            sb.Append("<Description>Sales Tax</Description>");
            sb.Append("<Value>1.59</Value>");
            sb.Append("</Charge>");
            sb.Append("</Charges>");
            sb.Append("<Memos>");
            sb.Append("<Memo>You will receive 15% off your next order with coupon code SAVE15</Memo>");
            sb.Append("</Memos>");
            sb.Append("</PickSlipAdditions>");*/
            sb.Append("<Packages>");
            foreach (Package package in recipient.Packages)
            {
                sb.Append("<Package>");
                sb.Append("<WeightUnit>KG</WeightUnit>");
                sb.AppendFormat("<Weight>{0}</Weight>", package.Weight);
                sb.Append("<DimensionsUnit>CM</DimensionsUnit>");
                sb.AppendFormat("<Length>{0}</Length>", package.Length);
                sb.AppendFormat("<Width>{0}</Width>", package.Width);
                sb.AppendFormat("<Height>{0}</Height>", package.Height);
                sb.AppendFormat("<PackageReference></PackageReference>");
                sb.Append("</Package>");
            }
            sb.Append("</Packages>");
            sb.Append("<Items>");
            foreach (Package p in recipient.Packages)
            {
                foreach (PackageItem i in p.PackageItems)
                {
                    sb.Append("<Item>");
                    if (shipMethod == "LGINTBPMU")
                    {
                        sb.AppendFormat("<Sku>{0}</Sku>", i.Description);
                    }
                    else//奶粉包税
                    {
                        string sku = repo.Context.MilkPowderSKUs.First(m => m.Description == i.Description).SKU;
                        sb.AppendFormat("<Sku>{0}</Sku>", sku);
                    }
                    sb.AppendFormat("<Quantity>{0}</Quantity>", i.Count);
                    sb.AppendFormat("<UnitPrice>{0}</UnitPrice>", i.UnitPrice);
                    sb.AppendFormat("<Description>{0}</Description>", i.Description);
                    sb.Append("<HSCode></HSCode>");
                    sb.Append("<CountryOfOrigin>GB</CountryOfOrigin>");
                    sb.Append("</Item>");
                }
            }           
            sb.Append("</Items>");
            sb.Append("</ImportRequest>");

            string data = sb.ToString();
            string response = HttpHelper.HttpPost("https://mercury.landmarkglobal.com/api/api.php", data);

            XmlDocument xml = new XmlDocument();
            xml.LoadXml(response);
            recipient.SuccessPaid = bool.Parse(xml.SelectNodes("ImportResponse/Result/Success")[0].InnerText);            

            var xmlPackages = xml.SelectNodes("ImportResponse/Result/Packages");
            for (int i = 0; i < recipient.Packages.Count; i++)
            {
                Package p = recipient.Packages.ElementAt(i);
                p.Status = recipient.SuccessPaid ?? false ? "SUCCESS" : "FAIL";
                if (p.Status == "SUCCESS")
                {
                    p.TrackNumber = xml.GetElementsByTagName("TrackingNumber")[i].InnerText;
                    p.Pdf = xml.GetElementsByTagName("LabelLink")[i].InnerText;
                }
                else
                {
                    p.Response = response;
                }
            }
        }
        order.SuccessPaid = order.Recipients.All(r => r.SuccessPaid ?? false);
    }

    private void SendTo4PX(Order order)
    {
        foreach (Recipient r in order.Recipients)
        {
            foreach (Package p in r.Packages)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("{");
                sb.Append("\"Token\": \"3EBACFA6-8137-42F7-A9F6-D67AC92C228D\",");
                sb.Append("\"Data\": {");
                sb.Append("\"TaxMode\": \"DDP\",");
                sb.Append("\"DestinationCountry\": \"China\",");
                sb.Append("\"ReceiptCountry\": \"China\",");
                sb.AppendFormat("\"Province\": \"{0}\",", r.Province);
                sb.AppendFormat("\"City\": \"{0}\",", r.City);
                sb.AppendFormat("\"District\": \"{0}\",", r.District);
                sb.Append("\"ConsigneeEMail\": \"\",");
                sb.AppendFormat("\"ConsigneeIDNumber\": \"{0}\",", r.IDNumber);
                sb.Append("\"ConsigneeIDBackCopy\": \"http://www.baidu.com/img/bd_logo1.png\",");
                sb.Append("\"ConsigneeIDFrontCopy\": \"http://www.baidu.com/img/bd_logo1.png\",");
                sb.AppendFormat("\"ConsigneeMobile\": \"{0}\",", r.PhoneNumber);
                sb.AppendFormat("\"ConsigneeName\": \"{0}\",", r.Name);
                sb.AppendFormat("\"ConsigneePostCode\": \"{0}\",", r.ZipCode);
                sb.AppendFormat("\"ConsigneeStreetDoorNo\": \"{0}\",", r.Address);
                sb.Append("\"ITEMS\": [");                
                foreach (PackageItem i in p.PackageItems)
                {
                    sb.Append("{");
                    string typeCode = repo.Context.Rank3Types.Where(rt => rt.Name == i.Description).First().Code;
                    sb.AppendFormat("\"ItemDeclareType\": \"{0}\",", typeCode);
                    sb.AppendFormat("\"ItemNameLocalLang\": \"{0}\",", i.Description);
                    sb.AppendFormat("\"ItemNumber\": \"{0}\",", i.Count);
                    sb.AppendFormat("\"ItemUnitPrice\": \"{0}\",", i.UnitPrice);
                    sb.AppendFormat("\"ItemTotalAmount\": \"{0}\"", i.Value);
                    if (i == p.PackageItems.Last())
                    {
                        sb.Append("}");
                    }
                    else
                    {
                        sb.Append("},");
                    }
                }
                sb.Append("],");
                sb.Append("\"ItemDeclareCurrency\": \"CNY\",");
                sb.Append("\"ServiceTypeCode\": \"IPS\",");
                sb.Append("\"UserCode\": \"KWTZQC\",");
                sb.Append("\"WarehouseOperateMode\": \"NON\",");
                sb.Append("\"CarrierCompanyCode\": \"OTHER\",");
                sb.AppendFormat("\"CarrierDeliveryNo\": \"{0}\",", p.Id);
                sb.AppendFormat("\"ShipperOrderNo\": \"{0}\",", p.Id);
                sb.Append("\"WarehouseCode\": \"GBLHR\",");
                sb.AppendFormat("\"OrderWeight\": \"{0}\",", p.Weight);
                sb.Append("\"DeliveryCompany\": \"TTKD\"");
                sb.Append("}");
                sb.Append("}");

                string data = sb.ToString();
                string result = HttpHelper.HttpPost("http://sandbox.tr.4px.com/TRSAPI/Agent/CreateAgent", data);
                var response = JsonConvert.DeserializeAnonymousType(result, new { Data = string.Empty, Message = string.Empty, ResponseCode = string.Empty});
                if (response.ResponseCode == "10000")
                {
                    p.Status = "SUCCESS";
                    p.TrackNumber = response.Data;
                    Generate4PXPdfNew(p);
                }
                else
                {
                    p.Status = "FAIL";
                }
                p.Response = response.Message;
            }
            r.SuccessPaid = r.Packages.All(p => p.Status == "SUCCESS");
        }
        order.SuccessPaid = order.Recipients.All(r => r.SuccessPaid.HasValue && r.SuccessPaid.Value);
    }

    private void Generate4PXPdf(Package p)
    {
        //获取大头笔
        StringBuilder sb = new StringBuilder();
        sb.Append("{");
        sb.Append("\"Token\": \"3EBACFA6-8137-42F7-A9F6-D67AC92C228D\",");
        sb.Append("\"Data\": [");
        sb.Append("{");
        sb.Append(string.Format("\"key\": \"{0}\",", p.Id));
        sb.Append(string.Format("\"prov\": \"{0}\",", p.Recipient.Province));
        sb.Append(string.Format("\"city\": \"{0}\",", p.Recipient.City));
        sb.Append(string.Format("\"area\": \"{0}\"", p.Recipient.District));
        sb.Append("}");
        sb.Append("]");
        sb.Append("}");

        string response = HttpHelper.HttpPost("http://sandbox.tr.4px.com/TRSAPI/Delivery/GetPODInfo", sb.ToString());
        var d = JsonConvert.DeserializeAnonymousType(response, new { Data = new JArray(), Message = string.Empty, ResponseCode = string.Empty });
        
        Document document = new Document();        
        BaseFont baseFont = BaseFont.CreateFont(HttpRuntime.AppDomainAppPath + "cart/simsun.TTF", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        iTextSharp.text.Font font = new iTextSharp.text.Font(baseFont, 9, 0);
        iTextSharp.text.Font fontBlod = new iTextSharp.text.Font(baseFont, 9, 1);

        string orderName = string.Format("CX999{0:d9}UK", p.Id);
        string filePath = HttpRuntime.AppDomainAppPath + string.Format("4px_files/{0}.pdf", orderName);
        PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(filePath, FileMode.Create));
        document.Open();

        PdfPCell cell;

        PdfPTable to = new PdfPTable(3);
        to.SetTotalWidth(new float[] { 10, 70, 20 });
        cell = new PdfPCell(new Phrase("收件：", fontBlod));
        cell.Rowspan = 3;
        cell.Border = iTextSharp.text.Rectangle.LEFT_BORDER | iTextSharp.text.Rectangle.TOP_BORDER;
        to.AddCell(cell);

        cell = new PdfPCell(new Phrase(p.Recipient.Name, font));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.PhoneNumber));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER | iTextSharp.text.Rectangle.RIGHT_BORDER;
        to.AddCell(cell);


        cell = new PdfPCell(new Phrase(p.Recipient.District, font));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.Province, font));
        cell.Border = iTextSharp.text.Rectangle.RIGHT_BORDER;
        cell.HorizontalAlignment = iTextSharp.text.Rectangle.ALIGN_CENTER;
        to.AddCell(cell);

        cell = new PdfPCell(new Phrase(p.Recipient.Address, font));
        cell.Border = iTextSharp.text.Rectangle.BOTTOM_BORDER;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("", font));
        cell.Border = iTextSharp.text.Rectangle.RIGHT_BORDER | iTextSharp.text.Rectangle.BOTTOM_BORDER;
        to.AddCell(cell);

        document.Add(to);

        PdfPTable from0 = new PdfPTable(3);
        cell = new PdfPCell(new Phrase("寄件：", font));
        cell.Rowspan = 2;
        from0.AddCell(cell);

        cell = new PdfPCell(new Phrase(string.Format("英国诚信物流"), font));
        from0.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("011-4327388")));
        from0.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("深圳宝安机场国内航空货站201-221"), font));
        cell.Colspan = 2;
        from0.AddCell(cell);

        document.Add(from0);

        PdfPTable detail = new PdfPTable(2);
        cell = new PdfPCell(new Phrase(string.Format("芜湖分拨包"), font));
        detail.AddCell(cell);

        BarcodeWriter barcodeWriter = new BarcodeWriter//312010605000100000000000000447
        {
            Format = BarcodeFormat.CODE_128,
            Options = new EncodingOptions
            {
                Height = 100,
                Width = 600
            }
        };
        string barcode = p.TrackNumber;
        Bitmap bitmap = barcodeWriter.Write(barcode);
        string pngFile = HttpRuntime.AppDomainAppPath + string.Format("4px_files/{0}.png", orderName);
        bitmap.Save(pngFile, System.Drawing.Imaging.ImageFormat.Png);

        iTextSharp.text.Image image = iTextSharp.text.Image.GetInstance(pngFile);
        cell = new PdfPCell(image);
        cell.Rowspan = 3;
        detail.AddCell(cell);

        cell = new PdfPCell(new Phrase(string.Format("皖 马鞍山"), font));
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("订单号：{0}", orderName), font));
        detail.AddCell(cell);

        document.Add(detail);

        PdfPTable sign = new PdfPTable(2);
        cell = new PdfPCell(new Phrase("签收人：", font));
        sign.AddCell(cell);
        cell = new PdfPCell(new Phrase("    年   月   日", font));
        sign.AddCell(cell);
        cell = new PdfPCell(new Phrase("签收人：    东莞长安二站", font));
        sign.AddCell(cell);
        cell = new PdfPCell(new Phrase("    年   月   日", font));
        sign.AddCell(cell);
        document.Add(sign);

        PdfPTable from1 = new PdfPTable(2);
        cell = new PdfPCell(new Phrase("英国诚信物流", font));
        from1.AddCell(cell);
        cell = new PdfPCell(image);
        cell.Rowspan = 2;
        from1.AddCell(cell);
        cell = new PdfPCell(new Phrase("深圳宝安机场国内航空货站201-221", font));
        from1.AddCell(cell);
        document.Add(from1);

        document.Close();
        writer.Close();

        p.Pdf = string.Format("4px_files/{0}.pdf", orderName);
    }

    private void Generate4PXPdfNew(Package p)
    {
        //获取大头笔
        StringBuilder sb = new StringBuilder();
        sb.Append("{");
        sb.Append("\"Token\": \"3EBACFA6-8137-42F7-A9F6-D67AC92C228D\",");
        sb.Append("\"Data\": [");
        sb.Append("{");
        sb.Append(string.Format("\"key\": \"{0}\",", p.Id));
        sb.Append(string.Format("\"prov\": \"{0}\",", p.Recipient.Province));
        sb.Append(string.Format("\"city\": \"{0}\",", p.Recipient.City));
        sb.Append(string.Format("\"area\": \"{0}\"", p.Recipient.District));
        sb.Append("}");
        sb.Append("]");
        sb.Append("}");

        string response = HttpHelper.HttpPost("http://sandbox.tr.4px.com/TRSAPI/Delivery/GetPODInfo", sb.ToString());
        var d = JsonConvert.DeserializeAnonymousType(response, new { Data = string.Empty, Message = string.Empty, ResponseCode = string.Empty });
        
        Document document = new Document();

        BaseFont baseFont = BaseFont.CreateFont(HttpRuntime.AppDomainAppPath + "cart/simsun.TTF", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        iTextSharp.text.Font font = new iTextSharp.text.Font(baseFont, 12, 0);
        iTextSharp.text.Font fontBold = new iTextSharp.text.Font(baseFont, 12, 1);
        iTextSharp.text.Font fontBig = new iTextSharp.text.Font(baseFont, 18, 1);
        iTextSharp.text.Font fontMiddle = new iTextSharp.text.Font(baseFont, 15, 0);

        string orderName = string.Format("CX999{0:d9}UK", p.Id);
        string fileName = HttpRuntime.AppDomainAppPath + string.Format("4px_files/{0}.pdf", orderName);
        PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(fileName, FileMode.Create));
        document.Open();

        PdfPCell cell;

        iTextSharp.text.Image logo = iTextSharp.text.Image.GetInstance(HttpRuntime.AppDomainAppPath + "cart/TKLogo.jpg");
        cell = new PdfPCell(logo);
        cell.Border = 0;
        PdfPTable head = new PdfPTable(1);
        head.AddCell(cell);
        document.Add(head);

        PdfPTable to = new PdfPTable(3);
        to.SetTotalWidth(new float[] { 10, 70, 20 });
        cell = new PdfPCell(new Phrase("收件：", fontBold));
        cell.Rowspan = 3;
        cell.Border = iTextSharp.text.Rectangle.LEFT_BORDER | iTextSharp.text.Rectangle.TOP_BORDER;
        to.AddCell(cell);

        cell = new PdfPCell(new Phrase(p.Recipient.Name, font));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.PhoneNumber));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER | iTextSharp.text.Rectangle.RIGHT_BORDER;
        to.AddCell(cell);


        cell = new PdfPCell(new Phrase(p.Recipient.District, font));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.Province, font));
        cell.Border = iTextSharp.text.Rectangle.RIGHT_BORDER;
        cell.HorizontalAlignment = iTextSharp.text.Rectangle.ALIGN_CENTER;
        to.AddCell(cell);

        cell = new PdfPCell(new Phrase(p.Recipient.Address, font));
        cell.PaddingBottom = 20;
        cell.Border = iTextSharp.text.Rectangle.BOTTOM_BORDER | iTextSharp.text.Rectangle.RIGHT_BORDER;
        //cell.Padding = 10;
        cell.Colspan = 2;
        to.AddCell(cell);


        document.Add(to);

        PdfPTable from0 = new PdfPTable(3);
        from0.SetTotalWidth(new float[] { 10, 70, 20 });
        cell = new PdfPCell(new Phrase("寄件：", fontBold));
        cell.Rowspan = 2;
        cell.Border = iTextSharp.text.Rectangle.LEFT_BORDER | iTextSharp.text.Rectangle.TOP_BORDER;
        from0.AddCell(cell);

        cell = new PdfPCell(new Phrase(string.Format("英国诚信物流"), font));
        cell.Border = 0;
        from0.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("011-4327388")));
        cell.Border = iTextSharp.text.Rectangle.RIGHT_BORDER | iTextSharp.text.Rectangle.TOP_BORDER;
        from0.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("深圳宝安机场国内航空货站201-221"), font));
        cell.PaddingBottom = 20;
        cell.Border = iTextSharp.text.Rectangle.RIGHT_BORDER | iTextSharp.text.Rectangle.BOTTOM_BORDER;
        cell.Colspan = 2;
        from0.AddCell(cell);

        document.Add(from0);

        PdfPTable detail = new PdfPTable(2);
        detail.SetWidths(new float[] { 50, 50 });
        cell = new PdfPCell(new Phrase(JArray.Parse(d.Data).First["package"].ToString(), fontBig));
        cell.Border = iTextSharp.text.Rectangle.LEFT_BORDER | iTextSharp.text.Rectangle.TOP_BORDER;
        detail.AddCell(cell);

        BarcodeWriter barcodeWriter = new BarcodeWriter
        {

            Format = BarcodeFormat.CODE_128,
            Options = new EncodingOptions
            {
                Height = 50,
                Width = 200,

            }
        };
        //barcodeWriter.Options.

        string barcode = p.TrackNumber;
        Bitmap bitmap = barcodeWriter.Write(barcode);
        string pngFile = HttpRuntime.AppDomainAppPath + string.Format("4px_files/{0}.png", orderName);
        bitmap.Save(pngFile, System.Drawing.Imaging.ImageFormat.Png);

        iTextSharp.text.Image image = iTextSharp.text.Image.GetInstance(pngFile);
        //image.SetAbsolutePosition(0, 350);
        cell = new PdfPCell(image);
        cell.Border = iTextSharp.text.Rectangle.RIGHT_BORDER;
        cell.Rowspan = 3;
        cell.Padding = 10;
        detail.AddCell(cell);

        cell = new PdfPCell(new Phrase(JArray.Parse(d.Data).First["result"].ToString(), fontMiddle));
        cell.Border = iTextSharp.text.Rectangle.LEFT_BORDER;
        cell.Padding = 10;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("订单号：{0}", orderName), font));
        cell.Padding = 10;
        cell.Border = iTextSharp.text.Rectangle.LEFT_BORDER;
        detail.AddCell(cell);

        document.Add(detail);

        PdfPTable sign = new PdfPTable(2);
        cell = new PdfPCell(new Phrase("签收人：", font));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        cell.Padding = 10;
        sign.AddCell(cell);
        cell = new PdfPCell(new Phrase("    年   月   日", font));
        cell.Padding = 10;
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        sign.AddCell(cell);
        cell = new PdfPCell(new Phrase("始发网点：    东莞长安二站", font));
        cell.Padding = 10;
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        sign.AddCell(cell);
        cell = new PdfPCell(new Phrase("    年   月   日", font));
        cell.Padding = 10;
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        sign.AddCell(cell);
        document.Add(sign);

        PdfPTable from1 = new PdfPTable(3);
        from1.SetWidths(new float[] { 10, 40, 50 });
        cell = new PdfPCell(new Phrase("寄件：", fontBold));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER | iTextSharp.text.Rectangle.LEFT_BORDER;
        from1.AddCell(cell);

        cell = new PdfPCell(new Phrase("英国诚信物流", font));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        from1.AddCell(cell);

        //iTextSharp.text.Image image1 = iTextSharp.text.Image.GetInstance(pngFile);
        cell = new PdfPCell(image);
        //cell.HorizontalAlignment =  iTextSharp.text.Rectangle.SECTION\\
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER | iTextSharp.text.Rectangle.RIGHT_BORDER | iTextSharp.text.Rectangle.BOTTOM_BORDER;

        cell.Padding = 10;
        cell.Rowspan = 2;
        from1.AddCell(cell);

        cell = new PdfPCell(new Phrase("深圳宝安机场国内航空货站201-221", font));
        cell.PaddingTop = 10;
        cell.Border = iTextSharp.text.Rectangle.LEFT_BORDER | iTextSharp.text.Rectangle.BOTTOM_BORDER;
        cell.Colspan = 2;
        from1.AddCell(cell);

        document.Add(from1);

        document.Close();
        writer.Close();

        p.Pdf = string.Format("4px_files/{0}.pdf", orderName);
    }
    
    protected void pay_Click(object sender, EventArgs e)
    { 
        if (balance >= totalPrice)
        {
            PayOrders(normalOrders);
            /*
            foreach (SheffieldOrder sOrder in sheffieldOrders)
            {
                PayOrders(sOrder.Orders);
                sOrder.HasPaid = true;
            }
            */
            
            apUser.Balance -= totalPrice;            
            repo.Context.SaveChanges();      
            
            Response.Redirect("Paid.aspx");            
        }
        else
        {
            Response.Redirect("RedirectToRecharge.aspx");
        }
    }        

    protected int GetCounter()
    {
        Application.Lock();
        int count = int.Parse(ConfigurationManager.AppSettings["bpostCount"]);
        int result = (int)(Application["counter"] ?? count);
        Application["counter"] = ++result;
        Application.UnLock();
        return result;
    }

    private bool UKMailCollection(Order o)
    {
        LoginWebRequest loginRequest = new LoginWebRequest();
        loginRequest.Username = "735534185@qq.com";
        loginRequest.Password = "UKMail123";
        UKMLoginResponse loginResponse = null;
        UKMAuthenticationServiceClient auth = new UKMAuthenticationServiceClient();
        try
        {
            loginResponse = auth.Login(loginRequest);
            //message.InnerText = loginResponse.Result.ToString();
        }
        catch (Exception ex)
        {
            o.SuccessPaid = false;
            o.UKMErrors = ex.Message;
            return false;
        }

        UKMConsignmentServiceClient consignmentService = new UKMConsignmentServiceClient();
        AddReturnWebRequest returnReq = new AddReturnWebRequest();
        returnReq.Username = "735534185@qq.com";
        returnReq.AuthenticationToken = loginResponse.AuthenticationToken;
        returnReq.AccountNumber = "S900118";
        returnReq.CollectionDate = o.PickupTime.Value.Date;
        returnReq.CollectionContactName = o.SenderName;
        //returnReq.CollectionBusinessName = "Delcam Ltd";
        returnReq.CollectionAddress = new AddressWebModel()
        {
            Address1 = o.SenderAddress1,
            Address2 = o.SenderAddress2,
            Address3 = o.SenderAddress3,
            CountryCode = "GBR",
            //County = "Berkshire",
            PostalTown = o.SenderCity,// "Slough",
            Postcode = o.SenderZipCode//"SL1 4PL"
        };
        //returnReq.CollectionEmail = o.SenderEmail;
        returnReq.CollectionTelephone = o.SenderPhone;
        //returnReq.CollectionCustomersRef = "";
        returnReq.ServiceKey = 401;
        returnReq.CollectionSpecialInstructions1 = "Please call me or text.";
        //returnReq.CollectionSpecialInstructions2 = "CollectionSpecialInstructions2";
        //returnReq.DeliverySpecialInstructions1 = "DeliverySpecialInstructions1";
        //returnReq.DeliverySpecialInstructions2 = "DeliverySpecialInstructions2";
        returnReq.DescriptionOfGoods1 = o.Recipients.Sum(r => r.Packages.Count).ToString();
        //returnReq.DescriptionOfGoods2 = "DescriptionOfGoods2";
        returnReq.CollectionTimeReady = returnReq.CollectionDate.AddHours(9);
        returnReq.CollectionOpenLunchtime = false;
        returnReq.CollectionLatestPickup = returnReq.CollectionDate.AddHours(17);
        returnReq.BookIn = false;
        UKMAddReturnToSenderWebResponse returnResponse = consignmentService.AddReturnToSender(returnReq);
        if (returnResponse.Result == UKMConsignmentServiceQA.UKMResultState.Successful)
        {
            o.UKMConsignmentNumber = returnResponse.ConsignmentNumber;
            return true;
        }
        else if (returnResponse.Result == UKMConsignmentServiceQA.UKMResultState.Failed)
        {
            int i = 1;
            foreach (UKMConsignmentServiceQA.UKMWebError error in returnResponse.Errors)
            {
                o.UKMErrors += i++ + error.Description;
                o.SuccessPaid = false;               
            }
            return false;
        }
        else
        {
            o.UKMErrors = returnResponse.Result.ToString();
            o.SuccessPaid = false;
            return false;
        }        
    }

    private void SendBpostLciFile(Order o)
    {
        lciFile = Bpost.GenerateLciFile("BPI/2015/9320", o, Application, repo);
        //System.Timers.Timer timer = new System.Timers.Timer(1);//60000 * 60

        //timer.Elapsed += new ElapsedEventHandler((s, e) => OnTimedEvent(s, e, o));
        //timer.AutoReset = false;
        //timer.Enabled = true;
        //Application["t"] = timer;
    }

    private void OnTimedEvent(object source, ElapsedEventArgs e, Order o)
    {
        string path0 = HttpRuntime.AppDomainAppPath + "bpost_files/" + username;
        File.Create(path0 + "/bpost_ftp_log_" + DateTime.Now.Ticks.ToString() + ".txt");
        FtpWeb ftp = new FtpWeb("ftp://transfert.post.be/out", "999_parcels", "dkfoec36");
        string path = HttpRuntime.AppDomainAppPath + "bpost_files/" + username;
        if (!Directory.Exists(path))
        {
            Directory.CreateDirectory(path);
        }
        string resultFile = "m2m_result_cn09320000_" + Path.GetFileName(lciFile);
        ftp.Download(path, resultFile);
        string file = Path.Combine(path, resultFile);
        StreamReader sr = new StreamReader(file);
        string header = sr.ReadLine();
        string status = header.Split('|')[5];
        List<string> attachedFiles = new List<string>();
       
        if (status == "SUCCES")
        {
            foreach (Recipient r in o.Recipients)
            {
                foreach (Package p in r.Packages)
                {
                    string line = sr.ReadLine();
                    if (line.Contains("BB001"))
                    {
                        string s = line.Split('|')[2];
                        if (s == "OK")
                        {
                            p.Status = "SUCCESS";                           
                            p.Pdf = Bpost.GeneratePdf(p, line.Split('|')[1]);
                            attachedFiles.Add(HttpRuntime.AppDomainAppPath + p.Pdf);
                        }
                        else
                        {
                            p.Status = "FAIL";
                        }
                    }
                }
                r.SuccessPaid = r.Packages.All(p => p.Status == "SUCCESS");
            }
            o.SuccessPaid = o.Recipients.All(r => r.SuccessPaid.Value);
        }
        repo.Context.SaveChanges();
        sr.Close();
                
        EmailService.SendEmailAync(Membership.GetUser().Email, "您在999Parcel的订单", "请查收您在999Parcel的订单。", attachedFiles.ToArray());
        
    }   
    
    private List<List<string>> SendTo51Parcel(Order order, UKShipmentType shipType, ServiceProvider provider, List<string> attachedFiles)
    {
        List<List<string>> responseList = new List<List<string>>();
        foreach (Recipient r in order.Recipients)
        {
            List<string> responses = SendTo51Parcel(r, shipType, provider, attachedFiles);
            responseList.Add(responses);
        }
        order.SuccessPaid = order.Recipients.All(r => r.SuccessPaid.Value);
        return responseList;
    }

    private List<string> SendTo51Parcel(Recipient recipient, UKShipmentType shipType, ServiceProvider provider, List<string> attachedFiles)
    {
        List<string> responses = new List<string>();
        foreach (Package p in recipient.Packages)
        {
            string response = SendTo51Parcel(p, shipType, provider, attachedFiles);
            responses.Add(response);
        }
        recipient.SuccessPaid = recipient.Packages.All(p => p.Status == "SUCCESS");
        return responses;
    }

    private string SendTo51Parcel(Package package, UKShipmentType shipType, ServiceProvider provider, List<string> attachedFiles)
    {
        YCShipmentServiceClient objService = new YCShipmentServiceClient("BasicHttpBinding_IYCShipmentService");
        ProcessShipmentRequestEx objRequest = new ProcessShipmentRequestEx();
        AuthenticationDetails authDetails = new AuthenticationDetails();
        authDetails.AccountNo = "yooboxsandbox";
        authDetails.UserName = "yooboxsandbox";
        authDetails.Password = "yooboxsandbox";
        objRequest.UKShipmentType = shipType;
        objRequest.AuthenticationDetails = authDetails;
        objRequest.OrderTotalValue = (double)package.Value.Value;
        objRequest.PackageType = PackageType.Package;
        objRequest.ServiceProvider = provider;
        objRequest.ShipFromAddress = package.Recipient.Order.SenderAddress1;
        objRequest.ShipFromAddress2 = package.Recipient.Order.SenderAddress2;
        objRequest.ShipFromAddress3 = package.Recipient.Order.SenderAddress3;
        objRequest.ShipFromCellPhone = package.Recipient.Order.SenderPhone;
        objRequest.ShipFromCity = package.Recipient.Order.SenderCity;
        objRequest.ShipFromCountry = "GB";
        objRequest.ShipFromEmail = Membership.GetUser().Email;
        objRequest.ShipFromName = package.Recipient.Order.SenderName;
        objRequest.ShipFromPostalCode = package.Recipient.Order.SenderZipCode;

        DateTime shippingDate = package.Recipient.Order.PickupTime.Value;
        if (shippingDate.DayOfWeek == DayOfWeek.Saturday)
            shippingDate = shippingDate.AddDays(2);
        if (shippingDate.DayOfWeek == DayOfWeek.Sunday)
            shippingDate = shippingDate.AddDays(1);
        objRequest.ShippingDate = shippingDate.ToString("yyyy-MM-dd");

        objRequest.ShipToChineseAddress = package.Recipient.Address;
        string pyAddress = package.Recipient.PyAddress;
        if (pyAddress.Length <= 24)
        {
            objRequest.ShipToAddress = pyAddress;
            objRequest.ShipToAddress2 = "";
            objRequest.ShipToAddress3 = "";
        }
        else if (pyAddress.Length <= 48)
        {
            objRequest.ShipToAddress = pyAddress.Substring(0, 24);
            objRequest.ShipToAddress2 = pyAddress.Substring(24);
            objRequest.ShipToAddress3 = "";
        }
        else
        {
            objRequest.ShipToAddress = pyAddress.Substring(0, 24);
            objRequest.ShipToAddress2 = pyAddress.Substring(24, 24);
            objRequest.ShipToAddress3 = pyAddress.Substring(48);
        }
        
        objRequest.ShipToCellPhone = package.Recipient.PhoneNumber;
        objRequest.ShipToCity = package.Recipient.PyCity;
        objRequest.ShipToCountry = "CN";
        objRequest.ShipToChineseCity = package.Recipient.City;
        objRequest.ShipToEmail = Membership.GetUser().Email;
        objRequest.ShipToName = package.Recipient.PyName;
        objRequest.ShipToChineseName = package.Recipient.Name;
        objRequest.ShipToPostalCode = package.Recipient.ZipCode;
        objRequest.ShipmentDetails = new ShipmentPackageDetails();
        objRequest.ShipmentDetails.ContentDescription = "GOODS";
        objRequest.ShipmentDetails.Height = package.Height;
        objRequest.ShipmentDetails.Length = package.Length;
        objRequest.ShipmentDetails.Width = package.Width;
        objRequest.ShipmentDetails.Weight = package.Weight;
        objRequest.ShipmentDetails.ItemDetails = new ProductDetails[package.PackageItems.Count];
        for (int i = 0; i < package.PackageItems.Count; i++)
        {
            objRequest.ShipmentDetails.ItemDetails[i] = new ProductDetails();
            objRequest.ShipmentDetails.ItemDetails[i].ProductName = package.PackageItems.ElementAt(i).Description;
            objRequest.ShipmentDetails.ItemDetails[i].Quantity = package.PackageItems.ElementAt(i).Count.Value;
            objRequest.ShipmentDetails.ItemDetails[i].UnitPrice = package.PackageItems.ElementAt(i).Value.Value;
        }

        string response;
        try
        {
            ProcessShipmentResponse objResponse = objService.ProcessShipmentEx(objRequest);
            if (objResponse.Status.StatusCode == ShipmentStatusCode.SUCCESS)
            {
                response = string.Format("PlaceOrder: StatusCode={0}; OrderRefrence={1}; TrackingNumber={2}", objResponse.Status.StatusCode, objResponse.OrderReference, objResponse.TrackingNumber);
                package.Status = "SUCCESS";
                package.TrackNumber = objResponse.OrderReference;
                
                string folder = string.Format("{0}files\\51Parcel\\{1}", HttpRuntime.AppDomainAppPath, Membership.GetUser().UserName);
                if (!Directory.Exists(folder))
                {
                    Directory.CreateDirectory(folder);
                }
                if (objResponse.CustomerLabelImage != null)
                {
                    string strPathDoc2 = string.Format("{0}\\CustomerLabel{1}.pdf", folder, objResponse.OrderReference);
                    FileStream file2 = new FileStream(strPathDoc2, FileMode.OpenOrCreate, FileAccess.ReadWrite);
                    file2.Write(objResponse.CustomerLabelImage, 0, objResponse.CustomerLabelImage.Length);
                    file2.Close();
                    attachedFiles.Add(strPathDoc2);
                }
                if (objResponse.CustomerDocumentImage != null)
                {
                    string strPathDoc2 = string.Format("{0}\\CustomerDocument{1}.pdf", folder, objResponse.OrderReference);
                    FileStream file2 = new FileStream(strPathDoc2, FileMode.OpenOrCreate, FileAccess.ReadWrite);
                    file2.Write(objResponse.CustomerDocumentImage, 0, objResponse.CustomerDocumentImage.Length);
                    file2.Close();
                    attachedFiles.Add(strPathDoc2);
                    package.Pdf = string.Format("files/51Parcel/{0}/{1}", Membership.GetUser().UserName, Path.GetFileName(strPathDoc2));
                }
                if (objResponse.CollectionReceiptImage != null)
                {
                    string strPathDoc2 = string.Format("{0}\\CollectionReceipt{1}.pdf", folder, objResponse.OrderReference);
                    FileStream file2 = new FileStream(strPathDoc2, FileMode.OpenOrCreate, FileAccess.ReadWrite);
                    file2.Write(objResponse.CollectionReceiptImage, 0, objResponse.CollectionReceiptImage.Length);
                    file2.Close();
                    attachedFiles.Add(strPathDoc2);
                }
                if (objResponse.UKLabelImage != null)
                {
                    string strPathDoc2 = string.Format("{0}\\UKLabel{1}.pdf", folder, objResponse.OrderReference);
                    FileStream file2 = new FileStream(strPathDoc2, FileMode.OpenOrCreate, FileAccess.ReadWrite);
                    file2.Write(objResponse.UKLabelImage, 0, objResponse.UKLabelImage.Length);
                    file2.Close();
                    attachedFiles.Add(strPathDoc2);
                }
                
            }
            else
            {
                response = string.Format("PlaceOrder: StatusCode={0}; Message={1}", objResponse.Status.StatusCode, objResponse.Status.StatusMessage);
                package.Status = "FAIL";
            }
        }
        catch (Exception ex)
        {
            response = string.Format("PlaceOrder Exception Message:{0}", ex.Message);
            package.Status = "EXCEPTION";
        }
        package.Response = response;
        
        EmailService.SendEmailAync(Membership.GetUser().Email, "您在999Parcel的订单", "请查收您在999Parcel的订单。", attachedFiles.ToArray());       

        return response;
    }
    
    private void SendBpost(Order o)
    {
        foreach (Recipient r in o.Recipients)
        {
            using (StringWriter sw = new StringWriter())
            {
                XmlTextWriter xtw = new XmlTextWriter(sw);
                xtw.WriteStartElement("?xml version=\"1.0\" encoding=\"utf-8\" ?");

                xtw.WriteStartElement("ImportRequest");
                xtw.WriteStartElement("Login");
                xtw.WriteStartElement("Username");
                xtw.WriteString("demoapi");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Password");
                xtw.WriteString("demo123");
                xtw.WriteEndElement();
                xtw.WriteEndElement();
                xtw.WriteStartElement("Test");
                xtw.WriteString("true");
                xtw.WriteEndElement();
                xtw.WriteStartElement("ClientID");
                xtw.WriteString("218");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Reference");
                xtw.WriteString("3245325");
                xtw.WriteEndElement();
                xtw.WriteStartElement("ShipTo");
                xtw.WriteStartElement("Name");
                xtw.WriteString("Test Company");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Attention");
                xtw.WriteString(r.Name);
                xtw.WriteEndElement();
                xtw.WriteStartElement("Address1");
                xtw.WriteString(r.Address);
                xtw.WriteEndElement();
                xtw.WriteStartElement("Address2");
                xtw.WriteString(string.Empty);
                xtw.WriteEndElement();
                xtw.WriteStartElement("Address3");
                xtw.WriteString(string.Empty);
                xtw.WriteEndElement();
                xtw.WriteStartElement("City");
                xtw.WriteString(r.City);
                xtw.WriteEndElement();
                xtw.WriteStartElement("State");
                xtw.WriteString("ON");
                xtw.WriteEndElement();
                xtw.WriteStartElement("PostalCode");
                xtw.WriteString(r.ZipCode);
                xtw.WriteEndElement();
                xtw.WriteStartElement("Country");
                xtw.WriteString("CN");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Phone");
                xtw.WriteString(r.PhoneNumber);
                xtw.WriteEndElement();
                xtw.WriteStartElement("Email");
                xtw.WriteString(string.Empty);
                xtw.WriteEndElement();
                xtw.WriteStartElement("Region");
                xtw.WriteString("Canada");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Residential");
                xtw.WriteString("true");
                xtw.WriteEndElement();
                xtw.WriteEndElement();
                xtw.WriteStartElement("ShipMethod");
                xtw.WriteString("LGINTSTD");
                xtw.WriteEndElement();
                xtw.WriteStartElement("ItemsCurrency");
                xtw.WriteString("USD");
                xtw.WriteEndElement();
                xtw.WriteStartElement("ProduceLabel");
                xtw.WriteString("true");
                xtw.WriteEndElement();
                xtw.WriteStartElement("LabelFormat");
                xtw.WriteString("PDF");
                xtw.WriteEndElement();
                xtw.WriteStartElement("LabelEncoding");
                xtw.WriteString("LINKS");
                xtw.WriteEndElement();
                xtw.WriteStartElement("ShipOptions");
                xtw.WriteStartElement("Option");
                xtw.WriteStartElement("Name");
                xtw.WriteString("dummy_option");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Value");
                xtw.WriteString("true");
                xtw.WriteEndElement();
                xtw.WriteEndElement();
                xtw.WriteEndElement();
                xtw.WriteStartElement("VendorInformation");
                xtw.WriteStartElement("VendorName");
                xtw.WriteString("Test Company Legal Name");
                xtw.WriteEndElement();
                xtw.WriteStartElement("VendorAddress1");
                xtw.WriteString("Sample Company Street");
                xtw.WriteEndElement();
                xtw.WriteStartElement("VendorAddress2");
                xtw.WriteString("Suite 135");
                xtw.WriteEndElement();
                xtw.WriteStartElement("VendorCity");
                xtw.WriteString("Santa Barbara");
                xtw.WriteEndElement();
                xtw.WriteStartElement("VendorState");
                xtw.WriteString("CA");
                xtw.WriteEndElement();
                xtw.WriteStartElement("VendorPostalCode");
                xtw.WriteString("93101");
                xtw.WriteEndElement();
                xtw.WriteStartElement("VendorCountry");
                xtw.WriteString("US");
                xtw.WriteEndElement();
                xtw.WriteEndElement();
                xtw.WriteStartElement("AdditionalFields");
                xtw.WriteStartElement("Field1");
                xtw.WriteString("Any type of data");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Field2");
                xtw.WriteString("Purchased with Credit Card");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Field3");
                xtw.WriteString("99000029327172321");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Field4");
                xtw.WriteString("123198012");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Field5");
                xtw.WriteString("Stored information");
                xtw.WriteEndElement();
                xtw.WriteEndElement();
                xtw.WriteStartElement("PickSlipAdditions");
                xtw.WriteStartElement("Charges");
                xtw.WriteStartElement("Charge");
                xtw.WriteStartElement("Description");
                xtw.WriteString("Gift Card Code: DISCOUNTHOUND");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Value");
                xtw.WriteString("-7.25");
                xtw.WriteEndElement();
                xtw.WriteEndElement();
                xtw.WriteStartElement("Charge");
                xtw.WriteStartElement("Description");
                xtw.WriteString("Sales Tax");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Value");
                xtw.WriteString("1.59");
                xtw.WriteEndElement();
                xtw.WriteEndElement();
                xtw.WriteEndElement();
                xtw.WriteStartElement("Memos");
                xtw.WriteStartElement("Memo");
                xtw.WriteString("You will receive 15% off your next order with coupon code SAVE15");
                xtw.WriteEndElement();
                xtw.WriteEndElement();
                xtw.WriteEndElement();               

                foreach (Package p in r.Packages)
                {
                    xtw.WriteStartElement("Package");
                    xtw.WriteStartElement("Weight");
                    xtw.WriteString(p.Weight.ToString());
                    xtw.WriteEndElement();
                    xtw.WriteStartElement("Length");
                    xtw.WriteString(p.Length.ToString());
                    xtw.WriteEndElement();
                    xtw.WriteStartElement("Width");
                    xtw.WriteString(p.Width.ToString());
                    xtw.WriteEndElement();
                    xtw.WriteStartElement("Height");
                    xtw.WriteString(p.Height.ToString());
                    xtw.WriteEndElement(); ;
                    xtw.WriteStartElement("PackageReference");
                    xtw.WriteString("98233312");
                    xtw.WriteEndElement();
                    xtw.WriteEndElement();
                }
               
                xtw.WriteStartElement("Items");
                xtw.WriteStartElement("Item");
                xtw.WriteStartElement("Sku");
                xtw.WriteString("7224059");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Quantity");
                xtw.WriteString("2");
                xtw.WriteEndElement();
                xtw.WriteStartElement("UnitPrice");
                xtw.WriteString("93.99");
                xtw.WriteEndElement();
                xtw.WriteStartElement("Description");
                xtw.WriteString("Women's Shoes");
                xtw.WriteEndElement();
                xtw.WriteStartElement("HSCode");
                xtw.WriteString("640399.30.00");
                xtw.WriteEndElement();
                xtw.WriteStartElement("CountryOfOrigin");
                xtw.WriteString("CN");
                xtw.WriteEndElement();
                xtw.WriteStartElement("CIFValue");
                xtw.WriteString("23.00");
                xtw.WriteEndElement();
                xtw.WriteEndElement();
                xtw.WriteEndElement();

                xtw.WriteEndElement();

                PostHelp ph = new PostHelp();
                string result = ph.PostXml("https://mercury.landmarkglobal.com/api/api.php", sw.ToString());

                StreamWriter w = new StreamWriter(AppDomain.CurrentDomain.BaseDirectory + "\\result.xml");
                w.Write(result);
                w.Close();
            }
        }
    }
}

public class PostHelp
{
    public string GetWebContent(string url)
    {
        Stream outstream = null;
        Stream instream = null;
        StreamReader sr = null;
        HttpWebResponse response = null;
        HttpWebRequest request = null;
        // 要注意的这是这个编码方式，还有内容的Xml内容的编码方式
        Encoding encoding = Encoding.GetEncoding("UTF-8");
        byte[] data = encoding.GetBytes(url);

        // 准备请求,设置参数
        request = System.Net.WebRequest.Create(url) as HttpWebRequest;
        request.Method = "POST";
        request.ContentType = "text/xml";
        //request.ContentLength = data.Length;

        outstream = request.GetRequestStream();
        outstream.Write(data, 0, data.Length);
        outstream.Flush();
        outstream.Close();
        //发送请求并获取相应回应数据

        response = request.GetResponse() as HttpWebResponse;
        //直到request.GetResponse()程序才开始向目标网页发送Post请求
        instream = response.GetResponseStream();

        sr = new StreamReader(instream, encoding);
        //返回结果网页(html)代码

        string content = sr.ReadToEnd();
        return content;
    }
    public string PostXml(string url, string strPost)
    {
        string result = "";

        StreamWriter myWriter = null;
        HttpWebRequest objRequest = (HttpWebRequest)System.Net.WebRequest.Create(url);
        objRequest.Method = "POST";
        //objRequest.ContentLength = strPost.Length;
        objRequest.ContentType = "text/xml";//提交xml 
        //objRequest.ContentType = "application/x-www-form-urlencoded";//提交表单
        try
        {
            myWriter = new StreamWriter(objRequest.GetRequestStream());
            myWriter.Write(strPost);
        }
        catch (Exception e)
        {
            return e.Message;
        }
        finally
        {
            myWriter.Close();
        }

        HttpWebResponse objResponse = (HttpWebResponse)objRequest.GetResponse();
        using (StreamReader sr = new StreamReader(objResponse.GetResponseStream()))
        {
            result = sr.ReadToEnd();
            sr.Close();
        }
        return result;
    }
}

public class XMLHelp
{
    private XDocument _document;

    public XDocument Document
    {
        get { return _document; }
        set { _document = value; }
    }
    private string _fPath = "";

    public string FPath
    {
        get { return _fPath; }
        set { _fPath = value; }
    }

    /// <summary>
    /// 初始化数据文件，当数据文件不存在时则创建。
    /// </summary>
    public void Initialize()
    {
        if (!File.Exists(this._fPath))
        {
            this._document = new XDocument(
            new XElement("entity", string.Empty)
            );
            this._document.Save(this._fPath);
        }
        else
            this._document = XDocument.Load(this._fPath);
    }

    public void Initialize(string xmlData)
    {
        XmlDocument doc = new XmlDocument();
        doc.LoadXml(xmlData);

        this._document = XmlDocumentExtensions.ToXDocument(doc, LoadOptions.None);
    }
    /// <summary>
    /// 清空用户信息
    /// </summary>
    public void ClearGuest()
    {
        XElement root = this._document.Root;
        if (root.HasElements)
        {
            XElement entity = root.Element("entity");
            entity.RemoveAll();
        }
        else
            root.Add(new XElement("entity", string.Empty));
    }


    ///LYJ 修改
    /// <summary>
    /// 提交并最终保存数据到文件。
    /// </summary>

    public void Commit()
    {
        try
        {
            this._document.Save(this._fPath);
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message, ex);
        }
    }

    /// <summary>
    /// 更新
    /// </summary>
    public void UpdateQrState(string PId, string state)
    {
        XElement root = this._document.Root;
        XElement entity = root.Element("entity");

        IEnumerable<XElement> elements = entity.Elements().Where(p =>
        p.Attribute("PId").Value == PId);
        if (elements.Count() == 0)
            return;
        else
        {
            XElement guest = elements.First();
            guest.Attribute("FQdState").Value = state;
            guest.Attribute("FQdTime").Value = DateTime.Now.ToString();
            Commit();
        }
    }

    public IEnumerable<XElement> GetXElement()
    {
        XElement root = this._document.Root;
        IEnumerable<XElement> elements = root.Elements();
        return elements;
    }



    public DataTable GetEntityTable()
    {
        DataTable dtData = new DataTable();
        XElement root = this._document.Root;
        IEnumerable<XElement> elements = root.Elements();

        foreach (XElement item in elements)
        {
            dtData.Columns.Add(item.Name.LocalName);
        }
        DataRow dr = dtData.NewRow();
        int i = 0;
        foreach (XElement item in elements)
        {
            dr[i] = item.Value;
            i = i + 1;
        }
        dtData.Rows.Add(dr);
        return dtData;
    }

}

public static class XmlDocumentExtensions
{
    public static XDocument ToXDocument(this XmlDocument document)
    {
        return document.ToXDocument(LoadOptions.None);
    }

    public static XDocument ToXDocument(this XmlDocument document, LoadOptions options)
    {
        using (XmlNodeReader reader = new XmlNodeReader(document))
        {
            return XDocument.Load(reader, options);
        }
    }
}