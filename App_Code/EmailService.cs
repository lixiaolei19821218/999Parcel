using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading;
using System.Web;

/// <summary>
/// EmailService 的摘要说明
/// </summary>
public static class EmailService
{
    /// <summary>
    /// 发送邮件
    /// </summary>
    /// <param name="mailTo">要发送的邮箱</param>
    /// <param name="mailSubject">邮箱主题</param>
    /// <param name="mailContent">邮箱内容</param>
    /// <returns>返回发送邮箱的结果</returns>
    public static bool SendEmail(List<string> mailTo, string mailSubject, string mailContent, params string[] attachmentPaths)
    {
        // 设置发送方的邮件信息,例如使用网易的smtp        
        string smtpServer = "999parcel.com"; //SMTP服务器
        string mailFrom = "support@999parcel.com"; //登陆用户名
        string userPassword = "999parcel";//登陆密码

        // 邮件服务设置
        SmtpClient smtpClient = new SmtpClient();
        smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;//指定电子邮件发送方式
        smtpClient.Host = smtpServer; //指定SMTP服务器
        smtpClient.Credentials = new System.Net.NetworkCredential(mailFrom, userPassword);//用户名和密码

        // 发送邮件设置        
        MailMessage mailMessage = new MailMessage();
        mailMessage.From = new MailAddress(mailFrom, "诚信物流");
        foreach (string to in mailTo)
        {
            mailMessage.To.Add(to);
        }
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
        catch
        {
            return false;
        }
    }

    public static bool SendEmail(string mailTo, string mailSubject, string mailContent, params string[] attachmentPaths)
    {
        List<string> mails = new List<string>();
        mails.Add(mailTo);
        return SendEmail(mails, mailSubject, mailContent, attachmentPaths);
    }
    /// <summary>
    /// 异步发送
    /// </summary>
    /// <param name="mailTo"></param>
    /// <param name="mailSubject"></param>
    /// <param name="mailContent"></param>
    /// <param name="attachmentPaths"></param>
    public static void SendEmailAync(List<string> mailTo, string mailSubject, string mailContent, params string[] attachmentPaths)
    {
        Thread sendThread = new Thread(SendThreadMethod);
        object[] mail = new object[] { mailTo, mailSubject, mailContent, attachmentPaths };
        sendThread.Start(mail);
    }

    public static void SendEmailAync(string mailTo, string mailSubject, string mailContent, params string[] attachmentPaths)
    {
        List<string> mails = new List<string>();
        mails.Add(mailTo);
        Thread sendThread = new Thread(SendThreadMethod);
        object[] mail = new object[] { mails, mailSubject, mailContent, attachmentPaths };
        sendThread.Start(mail);
    }

    public static void SendThreadMethod(object obj)
    {
        object[] contents = obj as object[];
        List<string> address = contents[0] as List<string>;
        string title = contents[1] as string;
        string content = contents[2] as string;
        string[] attachments = contents[3] as string[];
        SendEmail(address, title, content, attachments);
    }
}