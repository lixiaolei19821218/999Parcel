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
            string code = Request["validateCode"];

            if (String.Compare(Request.Cookies["validateCode"].Value, code, true) != 0)
            {
                this.Page.RegisterStartupScript(" ", "<script>alert('请输入正确的验证码。'); </script> ");
            }
            else
            {
                if (Membership.ValidateUser(user, pass))
                {
                    FormsAuthentication.RedirectFromLoginPage(user, false);
                }
                else
                {
                    message.Style["visibility"] = "visible";
                }
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