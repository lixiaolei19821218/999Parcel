using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_NewsEdit : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }
    private int id;

    protected void Page_Load(object sender, EventArgs e)
    {
        
            if (Session["NewsID"] != null)
            {
                if (int.TryParse(Session["NewsID"].ToString(), out id))
                {
                    if (!IsPostBack)
                    {
                    News news = repo.Context.News.Find(id);
                    if (news != null)
                    {
                        TextBoxTilte.Text = news.Title;
                        TextBoxContent.Text = news.Content;
                    }
                }
            }
        }
    }
    protected void Save_Click(object sender, EventArgs e)
    {
        News news;
        if (id == 0)
        {
           news = new News();
           repo.Context.News.Add(news);
        }
        else
        {
            news = repo.Context.News.Find(id);
        }
        news.Title = TextBoxTilte.Text;
        news.Content = TextBoxContent.Text;
        news.PulishTime = DateTime.Now;
        repo.Context.SaveChanges();
        Response.Redirect("/admin/news.aspx");
    }
}