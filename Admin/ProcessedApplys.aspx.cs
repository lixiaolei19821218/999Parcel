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

    public int PageSpan
    {
        get
        {
            return 10;
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

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {
        if (StartPage + PageSpan <= MaxPage)
        {
            Response.Redirect(string.Format("/Admin/ProcessedApplys.aspx?page={0}&startpage={0}", StartPage + PageSpan));
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
}