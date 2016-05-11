using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default3 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
       
         
    }
    protected string GetGreeting()
    {
        return "";
    }

    protected DateTime GetLastLoginTime()
    {
        return DateTime.Now;
    }

    public IEnumerable<News> GetNews()
    {
        return new List<News>();
    }
}