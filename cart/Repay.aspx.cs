using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class cart_Repay : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo
    {
        get;
        set;
    }

    public Package Package { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        string content = Request.QueryString["id"];
        if (content == null)
        {
            Response.Redirect("/cart/Parcel.aspx");
        }
        else
        {
            int id;
            if (int.TryParse(content, out id))
            {
                Package = repo.Context.Packages.FirstOrDefault(p => p.Id == id && p.Repay != null);
                if (Package == null)
                {
                    Response.Redirect("/cart/Parcel.aspx");
                }
            }
            else
            {
                Response.Redirect("/cart/Parcel.aspx");
            }
        }
    }
}