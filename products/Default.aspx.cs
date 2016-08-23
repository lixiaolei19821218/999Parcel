using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Web.Security;

public partial class product_Default : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    private Order order;

    protected void Page_Load(object sender, EventArgs e)
    {
        order = (Order)Session["Order"];
       
        if (order == null)
        {
            Response.Redirect("/");
        }

        if (IsPostBack)
        {
            int serviceID;
            if (int.TryParse(Request.Form["order"], out serviceID))
            {
                order.ServiceID = serviceID;
                ServiceView sv = new ServiceView(order.Service);
                order.PickupPrice = sv.GetPickupPrice(order);
                foreach (Recipient r in order.Recipients)
                {
                    foreach (Package p in r.Packages)
                    {
                        p.DeliverCost = sv.GetPackageDeliverPrice(p);
                    }
                }
                order.DeliverPrice = sv.GetDeliverPrice(order);

                //计算折扣
                MembershipUser user = Membership.GetUser();
                var discount = repo.Context.Discounts.Where(d => d.User == user.UserName && d.ServiceId == order.ServiceID).FirstOrDefault();
                if (discount != null)
                {
                    foreach (Recipient r in order.Recipients)
                    {
                        foreach (Package p in r.Packages)
                        {
                            p.Discount = discount.Value;
                        }
                    }
                }
                order.Discount = order.Recipients.Sum(r => r.Packages.Sum(p => p.Discount));
               
                Response.Redirect("product.aspx");
            }
        }
    }

    public IEnumerable<ServiceView> GetServices()
    {
        List<ServiceView> svs = new List<ServiceView>();

        //去掉荷兰邮政
        foreach (Service s in repo.Services.Where(s => s.Name.Contains("Bpost") || s.Name.Contains("Parcelforce") || s.Name.Contains("杂物包税专线")))
        {            
            svs.Add(new ServiceView(s));
        }
        
        return svs.OrderBy(s => s.PriceListID);
    }

    public IEnumerable<ServiceView> GetBpostAnd4PXServices()
    {
        List<ServiceView> svs = new List<ServiceView>();

        foreach (Service s in repo.Services.Where(s => (s.Name.Contains("Bpost") && !s.Name.Contains("DPD") || s.Name.Contains("杂物包税专线"))))
        {
            svs.Add(new ServiceView(s));
        }

        return svs.OrderBy(s => s.PriceListID);
    }

    public IEnumerable<ServiceView> GetPFServices()
    {
        List<ServiceView> svs = new List<ServiceView>();
        
        foreach (Service s in repo.Services.Where(s => s.Name.Contains("Parcelforce")))
        {
            svs.Add(new ServiceView(s));
        }

        return svs.OrderBy(s => s.PriceListID);
    }

    public IEnumerable<ServiceView> Get4PXServices()
    {
        List<ServiceView> svs = new List<ServiceView>();

        foreach (Service s in repo.Services.Where(s => s.Name.Contains("杂物包税专线")))
        {
            svs.Add(new ServiceView(s));
        }

        return svs.OrderBy(s => s.PriceListID);
    }

    public Order Order
    {
        get
        {
            return order;
        }
    }
}