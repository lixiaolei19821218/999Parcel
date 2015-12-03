using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Admin_CheckApply : System.Web.UI.Page
{
    private int pageSize = 20;

    [Ninject.Inject]
    public IRepository repo { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        (Master.FindControl("checkApply") as HtmlAnchor).Attributes["class"] = "on";
    }

    protected void ButtonPass_Click(object sender, EventArgs e)
    {
        int id;
        if (int.TryParse((sender as Button).Attributes["data-id"], out id))
        {
            RechargeApply apply = repo.Context.RechargeApplys.FirstOrDefault(r => r.Id == id);
            
            aspnet_User apUser = repo.Context.aspnet_User.First(u => u.UserName == apply.User);

            apply.IsApproved = true;
            
            apUser.Balance += apply.ApplyAmount;
            repo.Context.SaveChanges();
            Response.Redirect(Request.Path);
        }
    }
    protected void ButtonRefuse_Click(object sender, EventArgs e)
    {
        int id;
        if (int.TryParse((sender as Button).Attributes["data-id"], out id))
        {
            RechargeApply apply = repo.Context.RechargeApplys.FirstOrDefault(r => r.Id == id);
            apply.IsApproved = false;
            repo.Context.SaveChanges();
            Response.Redirect(Request.Path);
        }
    }

    public IEnumerable<RechargeApply> GetPageApplys()
    {
        return repo.Context.RechargeApplys.Where(r => !r.IsApproved.HasValue).OrderBy(p => p.Id).Skip((CurrentPage - 1) * pageSize).Take(pageSize);
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
            var applys = repo.Context.RechargeApplys.Where(r => !r.IsApproved.HasValue);
            if (applys.Count() == 0)
            {
                return 1;
            }
            else
            {
                return (int)Math.Ceiling((decimal)applys.Count() / pageSize);
            };
        }
    }
}