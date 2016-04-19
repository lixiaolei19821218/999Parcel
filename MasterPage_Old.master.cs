using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.IsAuthenticated)
            {
                loginDiv.Visible = false;
                welcomeDiv.Visible = true;
            }
            else
            {
                loginDiv.Visible = true;
                welcomeDiv.Visible = false;
            }
        }       
    }

    protected string GetGreeting()
    {
        return Context.User.Identity.Name;
    }
}
