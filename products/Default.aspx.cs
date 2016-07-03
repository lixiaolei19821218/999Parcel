using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;

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
                
                Response.Redirect("product.aspx");
            }
        }
    }

    public IEnumerable<ServiceView> GetServices()
    {
        List<ServiceView> svs = new List<ServiceView>();

        //去掉荷兰邮政
        foreach (Service s in repo.Services.Where(s => s.Name.Contains("Bpost") || s.Name.Contains("Parcelforce")))
        {            
            svs.Add(new ServiceView(s));
        }
        
        return svs.OrderBy(s => s.PriceListID);
    }

    public IEnumerable<ServiceView> GetBpostServices()
    {
        List<ServiceView> svs = new List<ServiceView>();
        
        foreach (Service s in repo.Services.Where(s => s.Name.Contains("Bpost") && !s.Name.Contains("DPD")))
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

    public Order Order
    {
        get
        {
            return order;
        }
    }
}