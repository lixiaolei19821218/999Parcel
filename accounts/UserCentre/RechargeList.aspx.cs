using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class accounts_UserCentre_RechargeList : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    private int pageSize = 20;

    protected void Page_Load(object sender, EventArgs e)
    {
        (Master.FindControl("rechange") as HtmlAnchor).Attributes["class"] = "on";
    }

    public decimal GetTotalApplyMoney()
    {
        string user = Membership.GetUser().UserName;
        var applys = repo.Context.RechargeApplys.Where(r => r.User == user);
        if (applys == null || applys.Count() == 0)
        {
            return 0;
        }
        else
        {
            return applys.Sum(r => r.ApplyAmount);
        }
    }

    public IEnumerable<RechargeApply> GetPageApplys()
    {
        string user = Membership.GetUser().UserName;
        return repo.Context.RechargeApplys.Where(r => r.User == user).OrderByDescending(p => p.Id).Skip((CurrentPage - 1) * pageSize).Take(pageSize);
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
    protected int MaxPage
    {
        get
        {
            string user = Membership.GetUser().UserName;
            var applys = repo.Context.RechargeApplys.Where(r => r.User == user);
            if (applys == null || applys.Count() == 0)
            {
                return 1;
            }
            else
            {
                return (int)Math.Ceiling((decimal)applys.Count() / pageSize);
            }
        }
    }
}