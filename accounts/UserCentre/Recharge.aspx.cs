using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.ModelBinding;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class accounts_UserCentre_Recharge : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        (Master.FindControl("rechange") as HtmlAnchor).Attributes["class"] = "on";
        
        string user = Membership.GetUser().UserName;
        
        if (repo.Context.RechargeApplys.Where(r => r.User == user && !r.IsApproved.HasValue).Count() != 0)
        {
            form.Visible = false;
            message.Visible = true;
        }
        else
        {
            form.Visible = true;
            message.Visible = false;
        }

        if (IsPostBack)
        {            
            RechargeApply apply = new RechargeApply();
            if (TryUpdateModel(apply, new FormValueProvider(ModelBindingExecutionContext)))
            {
                apply.User = user;
                apply.Time = DateTime.Now;
                repo.Context.RechargeApplys.Add(apply);
                repo.Context.SaveChanges();
            }
            Response.Redirect("RechargeList.aspx");
        }
    }    
}
