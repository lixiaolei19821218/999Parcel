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

    public Recipient Recipient
    {
        get
        {
            return sOrder.Orders.First().Recipients.First();
        }
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
            recipient.PyName = Request.Form.Get("hd_name").Trim();
            recipient.PyCity = Request.Form.Get("hd_city").Trim();
            recipient.PyAddress = Request.Form.Get("hd_street").Trim();

            List<Package> packages = new List<Package>();
            foreach (Recipient r in order.Recipients)
            {
                packages.AddRange(r.Packages);
            }
            for (int i = 0; i < packages.Count; i++)
            {
                int itemsCount = int.Parse(Request.Form.Get(string.Format("parcel-{0}-content-TOTAL_FORMS", i)));
                decimal weight = packages[i].Weight / itemsCount;
                packages[i].PackageItems.Clear();
                for (int j = 0; j < itemsCount; j++)
                {
                    PackageItem item = new PackageItem();
                    item.Description = Request.Form.Get(string.Format("parcel-{0}-content-{1}-type", i, j)).Trim();
                    item.TariffCode = "999999";
                    item.Count = int.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-quantity", i, j)));
                    decimal unitPrice = decimal.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-cost", i, j)));
                    item.Value = Math.Round(unitPrice * (decimal)item.Count, 2);
                    item.NettoWeight = Math.Round(weight, 3);
                    packages[i].PackageItems.Add(item);
                }
                packages[i].Value = packages[i].PackageItems.Sum(pi => pi.Value);
            }

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