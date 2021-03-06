﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Compensate : System.Web.UI.Page
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
            Response.Redirect("/Admin/Parcel.aspx");
        }
        else
        {
            int id;
            if (int.TryParse(content, out id))
            {
                Package = repo.Context.Packages.FirstOrDefault(p => p.Id == id);
                if (Package == null)
                {
                    Response.Redirect("/Admin/Parcel.aspx");
                }
            }
            else
            {
                Response.Redirect("/Admin/Parcel.aspx");
            }
        }

        if (!IsPostBack)
        {
            lbCompensate.InnerText = Package.Compensate == null ? "运费赔付" : "运费赔付(已赔付)";
            add.Disabled = Package.Compensate == null ? false : true;
            add.Value = Package.Compensate == null ? "0.01" : Package.Compensate.Value.ToString();
            ButtonAdd.Enabled = !add.Disabled;

            lbRepay.InnerText = Package.Repay == null ? "运费补交" : "运费补交(已补交)";
            sub.Disabled = Package.Repay == null ? false : true;
            sub.Value = Package.Repay == null ? "0.01" : Package.Repay.Value.ToString();
            ButtonSub.Enabled = !sub.Disabled;
            txtWeight.Disabled = txtHeight.Disabled = txtWidth.Disabled = txtLength.Disabled = sub.Disabled;
            txtWeight.Value = Package.Repay == null ? Package.Weight.ToString() : Package.Repay.Weight.ToString();
            txtLength.Value = Package.Repay == null ? Package.Length.ToString() : Package.Repay.Length.ToString();
            txtWidth.Value = Package.Repay == null ? Package.Width.ToString() : Package.Repay.Width.ToString();
            txtHeight.Value = Package.Repay == null ? Package.Height.ToString() : Package.Repay.Height.ToString();
        }
    }

    protected void ButtonAdd_Click(object sender, EventArgs e)
    {
        Compensate c = new Compensate() { PackageId = Package.Id, Value = decimal.Parse(add.Value), AdminAccount = Membership.GetUser().UserName, ApproveTime = DateTime.Now };
        repo.Context.Compensates.Add(c);
        string username = Package.Recipient.Order.User;
        aspnet_User user = repo.Context.aspnet_User.FirstOrDefault(u => u.UserName == username);
        user.Balance += decimal.Parse(add.Value);
        repo.Context.SaveChanges();
        Response.Redirect(Request.RawUrl);
    }

    protected void ButtonSub_Click(object sender, EventArgs e)
    {
        Repay r = new Repay() { PackageId = Package.Id,
            Weight = decimal.Parse(txtWeight.Value), Length = decimal.Parse(txtLength.Value), Width = decimal.Parse(txtWidth.Value), Height = decimal.Parse(txtHeight.Value),
            Value = decimal.Parse(sub.Value), AdminAccount = Membership.GetUser().UserName, ApproveTime = DateTime.Now };
        repo.Context.Repays.Add(r);
        string username = Package.Recipient.Order.User;
        aspnet_User user = repo.Context.aspnet_User.FirstOrDefault(u => u.UserName == username);
        user.Balance -= decimal.Parse(sub.Value);
        repo.Context.SaveChanges();
        Response.Redirect(Request.RawUrl);
    }
}