using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Admin_ProcessedApplys : System.Web.UI.Page
{
    private int pageSize = 20;

    [Ninject.Inject]
    public IRepository repo { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        (Master.FindControl("processedApplys") as HtmlAnchor).Attributes["class"] = "on";
    }

    public IEnumerable<RechargeApply> GetPageApplys()
    {
        return repo.Context.RechargeApplys.Where(r => r.IsApproved.HasValue).OrderByDescending(p => p.Id).Skip((CurrentPage - 1) * pageSize).Take(pageSize);
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
            var applys = repo.Context.RechargeApplys.Where(r => r.IsApproved.HasValue);
            if (applys.Count() == 0)
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