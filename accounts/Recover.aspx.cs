using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class accounts_Recover : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
    
    protected void Reset_Click(object sender, EventArgs e)
    {
        MembershipUser mUser;
        mUser = Membership.GetUser(Request["username"]);
        if (mUser == null)
        {
            message.InnerText = string.Format("没有找到用户：{0}，请输入正确的用户名", Request["username"]);
        }
        else
        {
            string newPassword;
            while ((newPassword = mUser.ResetPassword("answer")).Contains('&'))
            {

            }

            string requestString = Request.ServerVariables["SERVER_NAME"] + ":" + Request.ServerVariables["SERVER_PORT"] + "/accounts/ResetPassword.aspx?user=" + mUser.UserName + "&password=" + newPassword;
            string mailContent = "点击<a href=\"http://" + requestString + "\">找回密码</a>\r\n或复制链接以下链接到浏览器：\r\n" + requestString;
            SendEmail(mUser.Email, "设置新密码", mailContent);
            message.InnerText = string.Format("一封找回密码的邮件已经发送到您邮箱：{0}。", mUser.Email);
        }
    }

    public bool SendEmail(string mailTo, string mailSubject, string mailContent, params string[] attachmentPaths)
    {
        // 设置发送方的邮件信息,例如使用网易的smtp
        string smtpServer = "smtp.163.com"; //SMTP服务器
        string mailFrom = "iir_lee@163.com"; //登陆用户名
        string userPassword = "llc^181925";//登陆密码

        // 邮件服务设置
        SmtpClient smtpClient = new SmtpClient();
        smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;//指定电子邮件发送方式
        smtpClient.Host = smtpServer; //指定SMTP服务器
        smtpClient.Credentials = new System.Net.NetworkCredential(mailFrom, userPassword);//用户名和密码

        // 发送邮件设置        
        MailMessage mailMessage = new MailMessage(mailFrom, mailTo); // 发送人和收件人
        mailMessage.Subject = mailSubject;//主题
        mailMessage.Body = mailContent;//内容
        mailMessage.BodyEncoding = Encoding.UTF8;//正文编码
        mailMessage.IsBodyHtml = true;//设置为HTML格式
        mailMessage.Priority = MailPriority.Low;//优先级

        foreach (string path in attachmentPaths)
        {
            mailMessage.Attachments.Add(new Attachment(path));
        }

        try
        {
            smtpClient.Send(mailMessage); // 发送邮件
            return true;
        }
        catch (SmtpException ex)
        {
            return false;
        }
    }
}