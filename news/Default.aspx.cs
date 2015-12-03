using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default2 : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    private int pageSize = 20;
    
    public IEnumerable<News> GetNews()
    {
        return repo.Context.News;
    }

    protected void Page_Load(object sender, EventArgs e)
    {

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
}