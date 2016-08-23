using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Users : System.Web.UI.Page
{
    private int pageSize = 20;
    private MembershipUserCollection users;
    [Ninject.Inject]
    public IRepository repo
    {
        get;
        set;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string content = Request.Form["content"];
        if (content == null)
        {            
            users = Membership.GetAllUsers();
        }
        else
        {
            MembershipUser user = Membership.GetUser(content);
            if (user != null)
            {
                Response.Redirect(string.Format("/admin/userdetail.aspx?user={0}", user.UserName));
            }
            else
            {
                string username = Membership.GetUserNameByEmail(content);
                if (!string.IsNullOrEmpty(username))
                {
                    Response.Redirect(string.Format("/admin/userdetail.aspx?user={0}", username));

                }
                else
                {
                    message.InnerText = string.Format("没有查找到用户名或邮箱为{0}的用户。", content);
                    users = Membership.GetAllUsers();
                }
            }
        }
    }

    public IEnumerable<MembershipUser> GetPageApplys()
    {
        List<MembershipUser> userList = new List<MembershipUser>();
        foreach (MembershipUser user in users)
        {
            userList.Add(user);
        }
        return userList.OrderByDescending(u => u.CreationDate).Skip((CurrentPage - 1) * pageSize).Take(pageSize);
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
            if (users.Count == 0)
            {
                return 1;
            }
            else
            {
                return (int)Math.Ceiling((decimal)users.Count / pageSize);
            }
        }
    }
}