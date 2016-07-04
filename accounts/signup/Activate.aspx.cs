using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class accounts_signup_Activate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        username.Value = Request["username"];
    }
    protected void Activate_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrWhiteSpace(username.Value))
        {
            string name = username.Value.Trim();
            MembershipUser user = Membership.GetUser(name);
            if (user != null)
            {
                message.InnerText = string.Format("一封激活账号的邮件已发送到您的注册邮箱{0}，请在邮件中激活您的账号。", user.Email);
                string link = string.Format("http://{0}:{1}/accounts/signup/ActivateHandler.ashx?username={2}", Request.ServerVariables["SERVER_NAME"], Request.ServerVariables["SERVER_PORT"], user.UserName);
                string content = string.Format("请点击<a href='{0}'>激活</a>您的账号。\r\n或复制链接以下链接到浏览器：{1}\r\n", link, link);
                EmailService.SendEmailAync(user.Email, "请激活您的账号", content);
            }
            else
            {
                message.InnerText = string.Format("未能找到用户名为{0}的账号，请重新输入。", name);
            }
        }
    }
}