using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class accounts_UserCentre_OrderRecords : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        (Master.FindControl("total") as HtmlAnchor).Attributes["class"] = "on";
    }
}