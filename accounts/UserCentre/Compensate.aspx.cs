using System;
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

    private int pageSize = 20;

    public int PageSpan
    {
        get
        {
            return 20;
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

    public IEnumerable<CompensateRecord> GetCompensate()
    {
        string user = Membership.GetUser().UserName;
        var compensates = repo.Context.Compensates.Where(c => c.Package.Recipient.Order.User == user).
            Select( c => new CompensateRecord() { OrderId = c.Package.Recipient.OrderId.Value, TrackNUmber = c.Package.TrackNumber, Value = c.Value, ApproveTime = c.ApproveTime.Value } );
        var repays = repo.Context.Repays.Where(c => c.Package.Recipient.Order.User == user).
            Select(c => new CompensateRecord() { OrderId = c.Package.Recipient.OrderId.Value, TrackNUmber = c.Package.TrackNumber, Value = -c.Value, ApproveTime = c.ApproveTime.Value });

        List<CompensateRecord> records = compensates.ToList();
        records.AddRange(repays.ToList());
        return records.OrderByDescending(c => c.ApproveTime).Skip((CurrentPage - 1) * pageSize).Take(pageSize);
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