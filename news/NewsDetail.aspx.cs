using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class news_NewsDetail : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    private int id;
    private News news;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["id"] != null)
        {
            if (int.TryParse(Request.QueryString["id"].ToString(), out id))
            {
                news = repo.Context.News.Find(id);
            }
        }
        else
        {
            news = new News();
        }
    }
   
    public string GetTitle()
    {
        return news.Title;
    }

    public string GetContent()
    {
        return news.Content;
    }
}