using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default3 : System.Web.UI.Page
{
    public List<Order> List { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        List = new List<Order>();
        List.Add(new Order() { SenderName = "Amy" });
        rp.DataSource = List;
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        lb.Text = DateTime.Now.ToString();
        List.Add(new Order() { SenderName = "Lily" });
        //UpdatePanel1.Update();
    }

    public List<Order> GetOrder()
    {
        return List;
    }
}