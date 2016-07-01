<%@ WebHandler Language="C#" Class="ActivateHandler" %>

using System;
using System.Web;
using System.Web.Security;

public class ActivateHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string username = context.Request["username"];
        if (username != null)
        {
            MembershipUser user = Membership.GetUser(username);
            if (user != null)
            {
                user.IsApproved = true;
                Membership.UpdateUser(user);
                context.Response.Write(string.Format("您的账号已激活！欢迎访问<a href='http://www.999parcel.com'>诚信物流</a>"));
            }
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}