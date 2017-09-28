﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class accounts_UserCentre_Compensate : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    private int pageSize = 10;

    public int PageSpan
    {
        get
        {
            return 10;
        }
    }

    protected int StartPage
    {
        get
        {
            int page;
            page = int.TryParse(Request.QueryString["startpage"], out page) ? page : 1;
            return page > MaxPage ? MaxPage : page;
        }
    }

    public IEnumerable<Order> GetCompensate()
    {
        string user = Membership.GetUser().UserName;        
        return repo.Context.Orders.Where(o => o.User == user && o.Compensate.HasValue && o.Compensate > 0.0m).OrderByDescending(p => p.Id).Skip((CurrentPage - 1) * pageSize).Take(pageSize);
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
            string user = Membership.GetUser().UserName;
            var applys = repo.Context.RechargeApplys.Where(r => r.User == user);
            if (applys == null || applys.Count() == 0)
            {
                return 1;
            }
            else
            {
                return (int)Math.Ceiling((decimal)applys.Count() / pageSize);
            }
        }
    }

    protected int GetPageCount()
    {
        if (StartPage + PageSpan < MaxPage + 1)
        {
            btnNext.Visible = true;
            return StartPage + PageSpan;
        }
        else
        {
            btnNext.Visible = false;
            return MaxPage + 1;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {
        if (StartPage + PageSpan <= MaxPage)
        {
            Response.Redirect(string.Format("/accounts/UserCentre/Compensate.aspx?page={0}&startpage={0}", StartPage + PageSpan));
        }
    }
}