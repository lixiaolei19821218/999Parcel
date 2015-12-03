using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class accounts_ResetPassword : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            string user = Request.QueryString["user"];
            string password = Request.QueryString["password"];

            if (user != null && password != null && Membership.ValidateUser(user, password))
            {
                FormsAuthentication.RedirectFromLoginPage(user, false);
                MembershipUser mUser = Membership.GetUser(user);
                mUser.ChangePassword(password, Request["password2"]);
                message.InnerText = "密码已更新，将跳转到首页..";
                Thread.Sleep(2000);
                Response.Redirect("/");
            }
            else
            {
                message.InnerText = "用户名或零时密码错误。";
            }
            
        }
    }
    
    protected void OK_Click(object sender, EventArgs e)
    {
        
    }
}