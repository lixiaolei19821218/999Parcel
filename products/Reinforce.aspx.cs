using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class products_Reinforce : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    private Order order;
    private ServiceView sv;

    protected void Page_Load(object sender, EventArgs e)
    {
        order = (Order)Session["Order"];
        if (order == null)
        {
            Response.Redirect("/");
        }
        Service service = repo.Services.FirstOrDefault(s => s.Id == order.ServiceID);
        sv = new ServiceView(service);
    }

    public ServiceView ServiceView
    {
        get
        {
            return sv;
        }
    }

    public Reinforce Reinforce1
    {
        get
        {
            return repo.Reinforces.ElementAt(0);
        }
    }

    public Reinforce Reinforce2
    {
        get
        {
            return repo.Reinforces.ElementAt(1);
        }
    }

    public Order Order
    {
        get
        {
            return order;
        }
    }

    public IEnumerable<Recipient> Recipients
    {
        get
        {
            return order.Recipients;
        }
    }

    public decimal GetPackagePrice(Package package)
    {
        return sv.GetPackageDeliverPrice(package);
    }

    public decimal GetSendPrice()
    {
        return sv.GetSendPrice(order);
    }

    public IEnumerable<Package> GetAllPackages()
    {
        List<Package> packages = new List<Package>();
        foreach (Recipient r in order.Recipients)
        {
            packages.AddRange(r.Packages);
        }

        return packages;
    }
    protected void add2cart_Click(object sender, EventArgs e)
    {       
        Order old = repo.Context.Orders.Find(order.Id);
        
        if (Request.Form["reinforce"] == null)
        {
            old.ReinforceID = null;
        }
        else
        {
            old.ReinforceID = int.Parse(Request.Form["reinforce"]);
            old.Reinforce = repo.Context.Reinforces.Find(old.ReinforceID);
            old.Cost = sv.GetPrice(old);
        }
        
        repo.Context.SaveChanges();
        Response.Redirect("/cart/cart.aspx");
    }
}