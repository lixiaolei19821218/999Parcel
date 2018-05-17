using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class products_Providers : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }
    private Order order;
    public Order Order
    {
        get
        {
            return order;
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        order = (Order)Session["Order"];

        if (order == null)
        {
            Response.Redirect("/");
        }

        if (IsPostBack)
        {
            int providerID;
            if (int.TryParse(Request.Form["order"], out providerID))
            {
                Response.Redirect(string.Format("/products/default.aspx?providerID={0}", providerID));
            }
        }
    }

    public IEnumerable<Provider> GetProviders()
    {
        if (order.Recipients.All(r => r.Packages.All(p => p.Weight >= 4 && p.Weight <= 5)) ||
            order.Recipients.All(r => r.Packages.All(p => p.Weight >= 7 && p.Weight <= 8)))
        {
            return repo.Context.Providers.Where(p => p.Name == "自营奶粉包税" || p.Name == "Parcelforce" || p.Name == "顺丰奶粉包税");
        }
        else
        {
            //for now, we only have this serivce.
            return repo.Context.Providers.Where(p => p.Name == "Parcelforce");
        }
    }

    public decimal GetLowestPrice(Provider provider)
    {
        return provider.Services.Where(s => s.Valid).Min(s => new ServiceView(s).GetSendPrice(order));
    }
}