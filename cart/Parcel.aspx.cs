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

    private int pageSize = 20;
    public int PageSpan
    {
        get
        {
            return 10;
        }
    }

    private IEnumerable<Package> packages;

    protected void Page_Load(object sender, EventArgs e)
    {
        string user = Membership.GetUser().UserName;
        packages = repo.Context.Packages.Where(p => p.Recipient.Order.User == user && p.Status == "SUCCESS");
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

    public IEnumerable<Package> GetPageApplys()
    {
        return packages.OrderByDescending(p => p.Id).Skip((CurrentPage - 1) * pageSize).Take(pageSize);
    }

    protected int CurrentPage
    {
        get
        {
            int page;
            page = int.TryParse(Request.QueryString["page"], out page) ? page : 1;
            return page > MaxPage ? MaxPage : page;
        }
    }

    protected int StartPage
    {
        get
        {
            int page;
            page = int.TryParse(Request.QueryString["startpage"], out page) ? page : 1;
            return page > MaxPage ? MaxPage : page;
        }
    }

    protected int MaxPage
    {
        get
        {
            if (packages.Count() == 0)
            {
                return 1;
            }
            else
            {
                return (int)Math.Ceiling((decimal)packages.Count() / pageSize);
            };
        }
    }

    protected int GetPageCount()
    {
        if (StartPage + PageSpan < MaxPage + 1)
        {
            btnNext.Visible = true;
            return StartPage + PageSpan;
        }
        else
        {
            btnNext.Visible = false;
            return MaxPage + 1;
        }
    }

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {
        if (StartPage + PageSpan <= MaxPage)
        {
            Response.Redirect(string.Format("/cart/Parcel.aspx?page={0}&startpage={0}", StartPage + PageSpan));
        }
    }
}