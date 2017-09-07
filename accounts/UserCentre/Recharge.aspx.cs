using System;
using System.Collections.Generic;
using System.Configuration;
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
        rechange.Attributes["class"] = "on";
        
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
                apply.RechargeChannel = repo.Context.RechargeChannels.Find(apply.ChannelID);
                repo.Context.RechargeApplys.Add(apply);
                repo.Context.SaveChanges();
                List<string> mails = new List<string>(ConfigurationManager.AppSettings["Mails"].Split(';'));
                EmailService.SendEmailAync(mails, "新的充值申请 " + string.Format("{0:d9}", apply.Id), 
                    string.Format("申请单号：{0:d9}<br/>账户名称：{1}<br/>申请金额：{2}£<br/>申请日期：{3}<br/>申请方式：{4}", 
                    apply.Id, apply.User, apply.ApplyAmount, apply.Time, apply.RechargeChannel == null ? "" : apply.RechargeChannel.Name)
                    );
            }
            Response.Redirect("RechargeList.aspx");
        }
    }    
}
