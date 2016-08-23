using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_UserDetail : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo
    {
        get;
        set;
    }

    private IEnumerable<Discount> discounts;
    private string username;

    protected void Page_Load(object sender, EventArgs e)
    {
        username = Request["user"];
        if (username == null)
        {
            Response.Redirect("/");
        }
        else
        {
            discounts = repo.Context.Discounts.Where(d => d.User == username);
            var existServices = discounts.Select(d => d.ServiceId);
            foreach (Service service in repo.Services.Where(s => s.Valid && !existServices.Contains(s.Id)))
            {
                serviceList.Items.Add(new ListItem() { Text = service.Name, Value = service.Id.ToString() });
            }
        }
    }

    public IEnumerable<Discount> GetDiscounts()
    {
        if (username == null)
        {
            return null;
        }
        else
        {
            return discounts;
        }
    }

    protected void AddDiscount_Click(object sender, EventArgs e)
    {
        Discount discount = new Discount() { Approver = Membership.GetUser().UserName, ApproveTime = DateTime.Now, ServiceId = int.Parse(serviceList.SelectedValue), User = username, Value = 0.50m };
        repo.Context.Discounts.Add(discount);
        repo.Context.SaveChanges();

        Response.Redirect(Request.RawUrl);
    }

    protected void ButtonDel_Click(object sender, EventArgs e)
    {
        int id;
        if (int.TryParse((sender as Button).Attributes["data-id"], out id))
        {
            Discount discount = repo.Context.Discounts.Find(id);
            if (discount != null)
            {
                repo.Context.Discounts.Remove(discount);
                repo.Context.SaveChanges();
                Response.Redirect(Request.RawUrl);
            }
        }
    }
}