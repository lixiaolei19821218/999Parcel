using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            string user = Request["username"];
            string pass = Request["password"];
            string code = Request["validateCode"];

            if (Request.Cookies["validateCode"] == null)
            {
                this.Page.RegisterStartupScript(" ", "<script>alert('请重新获取验证码。'); </script> ");
                return;
            }
            if (String.Compare(Request.Cookies["validateCode"].Value, code, true) != 0)
            {
                this.Page.RegisterStartupScript(" ", "<script>alert('请输入正确的验证码。'); </script> ");
            }
            else
            {
                MembershipUser mUser = Membership.GetUser(user);

                if (mUser == null)
                {
                    user = Membership.GetUserNameByEmail(user);
                    if (string.IsNullOrEmpty(user))
                    {
                        message.InnerText = "用户名未注册。";
                        message.Style["visibility"] = "visible";
                        return;
                    }
                    else
                    {
                        mUser = Membership.GetUser(user);
                    }
                }

                if (!mUser.IsApproved)
                {
                    message.InnerText = "用户未激活，请在您的注册邮箱查收激活邮件。";
                    message.Style["visibility"] = "visible";
                }
                else if (mUser.IsLockedOut)
                {
                    message.InnerText = "用户被锁定，请重置您的密码。";
                    message.Style["visibility"] = "visible";
                }
                else
                {
                    if (Membership.ValidateUser(user, pass))
                    {
                        FormsAuthentication.RedirectFromLoginPage(user, false);
                    }
                    else
                    {
                        message.InnerText = "密码错误。";
                        message.Style["visibility"] = "visible";
                    }
                }
            }
        }
        else if (Request.IsAuthenticated)
        {
            Response.StatusCode = 403;
            Response.SuppressContent = true;
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}