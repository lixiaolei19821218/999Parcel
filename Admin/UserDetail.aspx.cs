﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.Services;
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
    public string Username
    {
        get
        {
            return username;
        }
    }

    public bool IsSuperAdmin
    {
        get
        {            
            string[] roles = Roles.GetRolesForUser();
            return roles.Contains("superAdmins") ? true : false;
        }
    }

    public decimal UserBalance
    {
        get
        {
            aspnet_User user = repo.Context.aspnet_User.FirstOrDefault(u => u.UserName == Username);
            return user == null ? 0m : user.Balance;
        }
    }

    public int UserOrderCount
    {
        get
        {
            aspnet_User user = repo.Context.aspnet_User.FirstOrDefault(u => u.UserName == Username);
            if (user == null)
            {
                return 0;
            }
            else
            {
                return repo.Context.Orders.Count(o => o.User == username && (o.HasPaid ?? false));
            }
        }
    }

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
            foreach (Discount d in discounts)
            {
                repo.Context.Entry<Discount>(d).Reload();
            }
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

    [WebMethod]
    public static bool Save(int id, decimal discount)
    {
        IRepository repo = new Repository();
        Discount d = repo.Context.Discounts.Find(id);
        if (d != null)
        {
            d.Value = discount;
            d.Approver = Membership.GetUser().UserName;
            d.ApproveTime = DateTime.Now;
            repo.Context.SaveChanges();
            return true;
        }
        else
        {
            return false;
        }
    }    
}