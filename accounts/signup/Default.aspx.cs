using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default2 : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            string firstname = Request["first_name"];
            string lastname = Request["last_name"];
            string email = Request["email"];
            string username = Request["username"];
            string password1 = Request["password1"];
            string password2 = Request["password2"];            
            string phone = Request["phone"];

            if (firstname == "" || lastname == "" || email == "" || username == "" || password1 == "" || password2 == "" || phone == "")
            {
                ReportError("所有字段都是必填。");
            }
            else if (password1 != password2)
            {
                ReportError("两次输入的密码不一致。");
            }
            else if (Server.HtmlEncode(password1) != password1)
            {
                ReportError("密码包含恶意字符。");
            }
            else
            {
                MembershipCreateStatus status;
                MembershipUser user = Membership.CreateUser(username, password1, email, "question", "answer", true, out status);

                if (status == MembershipCreateStatus.Success)
                {
                    Roles.AddUserToRole(username, "users");
                    user.Comment = string.Format("{0}|{1}|{2}", firstname, lastname, phone);
                    Membership.UpdateUser(user);

                    aspnet_User apUser = repo.Context.aspnet_User.First(u => u.UserName == user.UserName);
                    apUser.FirstName = firstname;
                    apUser.LastName = lastname;
                    apUser.CellPhone = phone;
                    repo.Context.SaveChanges();

                    FormsAuthentication.SetAuthCookie(username, false);
                    Response.Redirect("/");
                }
                else
                {
                    ReportError(status.ToString());
                }
            }
        }
    }

    protected void ReportError(string errorMsg)
    {
        message.InnerText = "Error: " + errorMsg;
        message.Visible = true;
    }

    [WebMethod]
    public static bool CheckEmail(string email)  //带参数的方法
    {
        string user = Membership.GetUserNameByEmail(email);
        if (string.IsNullOrEmpty(user))
        {
            return true;
        }
        else
        {
            return false;
        }        
    }

    [WebMethod]
    public static bool CheckUsername(string username)  //带参数的方法
    {
        MembershipUser user = Membership.GetUser(username);
        if (user == null)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}