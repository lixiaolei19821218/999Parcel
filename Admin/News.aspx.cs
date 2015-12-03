using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Admin_News : System.Web.UI.Page
{
    private int pageSize = 20;

    [Ninject.Inject]
    public IRepository repo { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        (Master.FindControl("news") as HtmlAnchor).Attributes["class"] = "on";
    }

    public IEnumerable<News> GetPageNews()
    {
        return repo.Context.News.OrderBy(p => p.Id).Skip((CurrentPage - 1) * pageSize).Take(pageSize);
    }

    protected int CurrentPage
    {
        get
        {
            int page;
            page = int.TryParse(Request.QueryString["page"], out page) ? page : 1;
            return page > MaxPage ? MaxPage : page;
        }
    }
    protected int MaxPage
    {
        get
        {
            var news = repo.Context.News;
            if (news.Count() == 0)
            {
                return 1;
            }
            else
            {
                return (int)Math.Ceiling((decimal)news.Count() / pageSize);
            };
        }
    }
    protected void AddNews_Click(object sender, EventArgs e)
    {
        Session.Add("NewsID", 0);
        Response.Redirect("/admin/newsedit.aspx");
    }
    protected void ButtonDelete_Click(object sender, EventArgs e)
    {
        int id;
        if (int.TryParse((sender as LinkButton).Attributes["data-id"], out id))
        {
            News news = repo.Context.News.FirstOrDefault(r => r.Id == id);
            repo.Context.News.Remove(news);
            repo.Context.SaveChanges();
            Response.Redirect(Request.Path);
        }
    }
    protected void ButtonEdit_Click(object sender, EventArgs e)
    {
        int id;
        if (int.TryParse((sender as LinkButton).Attributes["data-id"], out id))
        {
            Session.Add("NewsID", id);
            Response.Redirect("/Admin/NewsEdit.aspx");
        }
    }
}