using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Web.Security;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

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
                Service service = repo.Services.FirstOrDefault(s => s.Id == order.ServiceID);
                order.Service = service;
                ServiceView sv = new ServiceView(order.Service);
                order.PickupPrice = sv.GetPickupPrice(order);
                foreach (Recipient r in order.Recipients)
                {
                    foreach (Package p in r.Packages)
                    {
                        p.DeliverCost = sv.GetPackageDeliverPrice(p);
                        p.FinalCost = p.DeliverCost;
                    }
                }
                order.DeliverPrice = sv.GetDeliverPrice(order);                

                //计算折扣
                MembershipUser user = Membership.GetUser();
                var discount = repo.Context.Discounts.Where(d => d.User == user.UserName && d.ServiceId == order.ServiceID).FirstOrDefault();
                if (discount != null)
                {
                    repo.Context.Entry<Discount>(discount).Reload();
                    foreach (Recipient r in order.Recipients)
                    {
                        foreach (Package p in r.Packages)
                        {
                            p.Discount = discount.Value;
                            p.FinalCost = p.DeliverCost - p.Discount;
                        }
                    }
                }
                order.Discount = order.Recipients.Sum(r => r.Packages.Sum(p => p.Discount));
                order.Cost = order.PickupPrice + order.DeliverPrice - order.Discount;
                order.User = Membership.GetUser().UserName;
                /*
                JsonSerializerSettings settings = new JsonSerializerSettings() { ReferenceLoopHandling = ReferenceLoopHandling.Serialize, PreserveReferencesHandling = PreserveReferencesHandling.Objects };
                string orderString = JsonConvert.SerializeObject(order, Formatting.Indented, settings);
                HttpCookie cookie = new HttpCookie("Order");
                cookie.Value = orderString;
                cookie.Expires = DateTime.Now.AddDays(1);
                Response.AppendCookie(cookie);
                Server.Transfer("product.aspx");
                */
                //order.OrderTime = DateTime.Now;
                //repo.Context.Orders.Add(order);
                //repo.Context.SaveChanges();
                Response.Redirect(string.Format("product.aspx?serviceId={0}", order.ServiceID));
            }
        }
    }
    /*
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
    */
    public IEnumerable<ServiceView> GetBpostAnd4PXServices()
    {
        List<ServiceView> svs = new List<ServiceView>();
        if (Order.Recipients.All(r => r.Packages.All(p => p.Weight < 8m && (p.Length * p.Width * p.Height) / 5000m < 8)))//奶粉包税
        {
            foreach (Service s in repo.Services.Where(s => (s.Name.Contains("Bpost") && !s.Name.Contains("DPD") || s.Name.Contains("杂物包税专线") || s.Name.Contains("奶粉包税专线"))))
            {
                svs.Add(new ServiceView(s));
            }
        }
        else
        {
            foreach (Service s in repo.Services.Where(s => (s.Name.Contains("Bpost") && !s.Name.Contains("DPD") || s.Name.Contains("杂物包税专线"))))
            {
                svs.Add(new ServiceView(s));
            }
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

    public IEnumerable<ServiceView> GetServices()
    {
        int providerId;
        if (int.TryParse(Request["providerId"], out providerId))
        {
            Provider provider = repo.Context.Providers.Find(providerId);
            if (provider == null)
            {
                return new List<ServiceView>();
            }
            else
            {
                IEnumerable<ServiceView> sv;
                if (order.Recipients.All(r => r.Packages.All(p => p.Weight >= 7 && p.Weight <= 8)))
                {
                    sv = provider.Services.Where(s => s.Valid && s.Name.Contains("自营奶粉包税6罐")).Select(s => new ServiceView(s));
                }
                else if (order.Recipients.All(r => r.Packages.All(p => p.Weight >= 4 && p.Weight <= 5)))
                {
                    sv = provider.Services.Where(s => s.Valid && s.Name.Contains("自营奶粉包税4罐")).Select(s => new ServiceView(s));
                }
                else
                {
                    //sv = provider.Services.Where(s => s.Valid).Select(s => new ServiceView(s));
                    sv = new List<ServiceView>();
                }
                //var sv = repo.Context.Services.Where(s => s.ProviderId == providerId).Select(s => new ServiceView(s));
                return sv;
            }
        }
        else
        {
            return new List<ServiceView>();
        }
    }

    public string GetHtml(ServiceView sv)
    {
        if (sv.Name.Contains("Parcelforce"))
        {
            return "<span style=\"font - family:YouYuan\">请联系客服</span>";
        }
        else
        {
            return string.Format("<button class=\"btn btn-warning\" name=\"order\" value=\"{0}\" type=\"submit\">购买</button>", sv.Id);
        }
    }
    /*
    public IEnumerable<ServiceView> Get4PXServices()
    {
        List<ServiceView> svs = new List<ServiceView>();

        foreach (Service s in repo.Services.Where(s => s.Name.Contains("杂物包税专线")))
        {
            svs.Add(new ServiceView(s));
        }

        return svs.OrderBy(s => s.PriceListID);
    }
    */
    public Order Order
    {
        get
        {
            return order;
        }
    }
}