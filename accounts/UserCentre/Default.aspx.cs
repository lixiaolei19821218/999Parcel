using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.ModelBinding;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class accounts_UserCentre_Default : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    private MembershipUser user;
    private aspnet_User apUser;

    public MembershipUser User
    {
        get
        {
            return user;
        }
    }

    public aspnet_User APUser
    {
        get
        {

            return apUser;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        //(Master.FindControl("rechange") as HtmlAnchor).Attributes["class"] = "";
        (Master.FindControl("default") as HtmlAnchor).Attributes["class"] = "on";

        user = Membership.GetUser();
        apUser = repo.Context.aspnet_User.First(u => u.UserName == user.UserName);
    }

    
}