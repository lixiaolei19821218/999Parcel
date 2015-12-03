using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class cart_Parcel : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo
    {
        get;
        set;
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public IEnumerable<Package> GetPackages()
    {
        string username = Membership.GetUser().UserName;
        IEnumerable<Order> orders = from o in repo.Orders where o.User == username && !(o.IsSheffieldOrder ?? false) && (o.HasPaid ?? false) select o;

        List<Package> packages = new List<Package>();
        foreach (Order o in orders)
        {
            foreach (Recipient r in o.Recipients)
            {
                if ((r.SuccessPaid ?? false))
                {
                    packages.AddRange(r.Packages);
                }
            }
        }

        return packages;
    }
}