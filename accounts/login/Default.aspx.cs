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
            
            if (Membership.ValidateUser(user, pass))
            {
                FormsAuthentication.RedirectFromLoginPage(user, false);
            }
            else
            {
                message.Style["visibility"] = "visible";
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