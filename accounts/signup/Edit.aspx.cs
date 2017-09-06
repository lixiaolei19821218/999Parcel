using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class accounts_signup_Edit : System.Web.UI.Page
{
    public aspnet_User ApUser { get; set; }
    public MembershipUser MsUser { get; set; }

    [Ninject.Inject]
    public IRepository repo { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        MsUser = Membership.GetUser();
        if (MsUser == null)
        {
            return;
        }
        ApUser = repo.Context.aspnet_User.First(u => u.UserName == MsUser.UserName);
    }

    [WebMethod]
    public static bool CheckEmail(string email)  //带参数的方法
    {
        string user = Membership.GetUserNameByEmail(email);
        if (string.IsNullOrEmpty(user) || user == Membership.GetUser().UserName)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MsUser.Email = Request["email"];
        Membership.UpdateUser(MsUser);
        ApUser.FirstName = Request["first_name"];
        ApUser.LastName = Request["last_name"];
        ApUser.CellPhone = Request["phone"];
        repo.Context.SaveChanges();
        Response.Redirect("/accounts/usercentre/");
    }
}