using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class accounts_logout_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.IsAuthenticated)
        {
            string path = Request["next"];
            FormsAuthentication.SignOut();
            Response.Redirect(path);
        }
        else
        {
            FormsAuthentication.RedirectToLoginPage();
        }
    }
}