using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class cart_OrderDetail : System.Web.UI.Page
{
    private Order order;

    [Ninject.Inject]
    public IRepository repo
    {
        get;
        set;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["id"] == null)
        {
            Response.Redirect("/");
        }

        int id;        
        if (int.TryParse(Session["id"].ToString(), out id))
        {
            order = repo.Context.Orders.Find(id);
        }
        else
        {
            order = new Order();
        }

        if (Order.SuccessPaid ?? false)
        {
            ButtonSuccessPaid.Visible = false;
            ButtonSuccessPaid.Width = 0;
            ButtonReSend.Visible = false;
            ButtonEdit.Visible = false;
        }
        else
        {
            ButtonSuccessPaid.Visible = true;
            hrConfirm.Visible = true;
            ButtonReSend.Visible = true;
            ButtonEdit.Visible = true;
        }

        if  (Order.Service.PickUpCompany.Contains("999") && !(Order.HasPickedUp ?? false))
        {            
            ButtonPickedUp.Visible = true;
            hrConfirm.Visible = true;
        }
        else
        {                  
            ButtonPickedUp.Visible = false;
            ButtonPickedUp.Width = 0;
        }
    }

    public IEnumerable<Recipient> GetRecipients()
    {
        int id;
        if (int.TryParse(Session["id"].ToString(), out id))
        {
            Order order = repo.Context.Orders.Find(id);
            if (order != null)
            {
                return order.Recipients;
            }
        }
        return new Recipient[0];
    }

    public Order Order
    {
        get
        {            
            return order;
        }
    }

    public string GetPickupTime(Order o)
    {
        if (o.Service.PickUpCompany.Trim() == "999Parcel" || o.Service.PickUpCompany.Trim() == "999 Parcel")
        {
            if (o.PickupTime.Value.Hour <= 12)
            {
                return o.PickupTime.Value.ToString() + " AM " + ((o.HasPickedUp ?? false) ? "<span style=\"color: green; \">已取件</span>" : "<span style=\"color: red; \">未取件</span>");
            }
            else
            {
                return o.PickupTime.Value.ToString() + " PM " + ((o.HasPickedUp ?? false) ? "<span style=\"color: green; \">已取件</span>" : "<span style=\"color: red; \">未取件</span>");
            }
        }
        else
        {
            return o.PickupTime.HasValue ? o.PickupTime.Value.ToString() : "";
        }
    }

    public string GetPacakgeDetail(Package p)
    {
        if (p.Recipient.Order.HasPaid ?? false)
        {
            if (p.Recipient.Order.Service.Name.Contains("Parcelforce") || p.Recipient.Order.Service.Name.Contains("顺丰奶粉包税"))
            {
                return (p.Status == "SUCCESS") ? "<a href=\"/" + p.Pdf + "\">点击下载</a>" : "<a title=\"错误信息\" class=\"btn-link\" data-container=\"body\" data-toggle=\"popover\" data-placement=\"right\" data-content=\"" + p.Response + "\">错误详情</a>";
            }
            else if (p.Recipient.Order.Service.Name.Contains("Bpost"))
            {
                if (!string.IsNullOrEmpty(p.Status))
                {
                    if (p.Status == "SUCCESS")
                    {
                        return "<a href=\"/" + p.Pdf + "\">点击下载</a>";
                    }
                    else
                    {
                        return "<a title=\"错误信息\" class=\"btn-link\" data-container=\"body\" data-toggle=\"popover\" data-placement=\"right\" data-content=\"" + p.Response + "\">错误详情</a>";
                    }
                }
                else
                {
                    if (string.IsNullOrWhiteSpace(p.Recipient.Order.UKMErrors))
                    {
                        return "<a title=\"已发送Bpost\" class=\"btn-link\" data-container=\"body\" data-toggle=\"popover\" data-placement=\"right\" data-content=\"" + "等待Bpost返回结果" + "\">已发送Bpost</a>";
                    }
                    else
                    {
                        return "<a title=\"错误信息\" class=\"btn-link\" data-container=\"body\" data-toggle=\"popover\" data-placement=\"right\" data-content=\"" + p.Recipient.Order.UKMErrors + "\">错误详情</a>";
                    }
                }
            }
            else if (p.Recipient.Order.Service.Name.Contains("杂物包税"))
            {
                return (p.Status == "SUCCESS") ? "发送成功" : "<a title=\"错误信息\" class=\"btn-link\" data-container=\"body\" data-toggle=\"popover\" data-placement=\"right\" data-content=\"" + p.Response + "\">错误详情</a>";
            }
            else if (p.Recipient.Order.Service.Name.Contains("自营奶粉包税"))
            {
                if (!string.IsNullOrEmpty(p.Status))
                {
                    if (p.Status == "SUCCESS")
                    {
                        return "<a href=\"/" + p.Pdf + "\">点击下载</a>";
                    }
                    else
                    {
                        return "<a title=\"错误信息\" class=\"btn-link\" data-container=\"body\" data-toggle=\"popover\" data-placement=\"right\" data-content=\"" + p.Response + "\">错误详情</a>";
                    }
                }
                else
                {
                    return string.Empty;
                }
            }
            else
            {
                return string.Empty;
            }
        }
        else
        {
            return "未付款";
        }
    }

    public string Get4PXVisible(Package p)
    {
        if (p == null)
        {
            return string.Empty;
        }
        else
        {
            if (p.Recipient.Order.Service.Name.Contains("杂物包税"))
            {
                return "<th class=\"tac\"></th>";
            }
            else
            {
                return string.Empty;
            }
        }
    }

    public string Get4PXOperation(Package p)
    {
        if (p == null)
        {
            return string.Empty;
        }
        else
        {
            if (p.Recipient.Order.Service.Name.Contains("杂物包税"))
            {
                if (p.Recipient.Order.HasPaid ?? false)
                {
                    return string.Format("<td class=\"tac\"><input type=\"submit\" class=\"btn btn-info btn-small edit\" data-id=\"{0}\" name=\"edit\" value=\"修改\" style=\"padding: 0px 10px;\" /></td>", p.Id);
                }
                else
                {
                    return string.Format("<td class=\"tac\"><input type=\"submit\" class=\"btn btn-danger btn-small del\" data-id=\"{0}\" name=\"delete\" value=\"删除\" style=\"padding: 0px 10px;\" /></td>", p.Id);
                }
            }
            else
            {
                return string.Empty;
            }
        }
    }

    public bool Get4PXEdit(Package p)
    {
        if (p == null)
        {
            return false;
        }
        if (p.Recipient.Order.Service.Name.Contains("杂物包税"))
        {
            if (p.Recipient.Order.HasPaid ?? false)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }

    public bool Get4PXDelete(Package p)
    {
        if (p == null)
        {
            return false;
        }
        if (p.Recipient.Order.Service.Name.Contains("杂物包税"))
        {
            if (p.Recipient.Order.HasPaid ?? false)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        else
        {
            return false;
        }
    }

    public string GetStatus(Recipient p)
    {
        if (p.Order.HasPaid ?? false)
        {
            return (p.SuccessPaid ?? false) ? "<div style=\"float:right;font-size:medium;color:green;\">发送成功</div>" : "<div style=\"float:right;font-size:medium;color:red;\">发送失败</div>";
        }
        else
        {
            return "<div style=\"float:right;font-size:medium;color:green;\">未付款</div>";
        }
    }
    protected void ButtonSub_Click(object sender, EventArgs e)
    {
        aspnet_User apUser = repo.Context.aspnet_User.Where(u => u.UserName == Order.User).FirstOrDefault();
        if (apUser != null)
        {
            decimal temp = decimal.Parse(sub.Value);
            Order.AfterPayment = temp;
            apUser.Balance -= temp;
            repo.Context.SaveChanges();
            message.Text = string.Format("已成功补交{0}英镑。", temp);
        }
    }

    protected void ButtonAdd_Click(object sender, EventArgs e)
    {
        aspnet_User apUser = repo.Context.aspnet_User.Where(u => u.UserName == Order.User).FirstOrDefault();
        if (apUser != null)
        {
            decimal temp = decimal.Parse(add.Value);
            Order.Compensate = temp;
            apUser.Balance += temp;
            repo.Context.SaveChanges();
            message.Text = string.Format("已成功赔付{0}英镑。", temp);
        }
    }

    protected void ButtonSuccessPaid_Click(object sender, EventArgs e)
    {
        Order.SuccessPaid = true;
        foreach (Recipient r in Order.Recipients)
        {
            r.SuccessPaid = true;
        }
        repo.Context.SaveChanges();
        message2.Text = "已确认该订单已经成功发送。";
    }

    protected void ButtonPickedUp_Click(object sender, EventArgs e)
    {
        Order.HasPickedUp = true;
        repo.Context.SaveChanges();
        message2.Text = "已确认该订单已由999 Parcel取件。";
    }

    public string GetPickupNumber(Order o)
    {
        if (string.IsNullOrEmpty(o.UKMConsignmentNumber))
        {
            return string.Empty;
        }
        else
        {
            return "取件号：" + o.UKMConsignmentNumber;
        }
    }

    protected void ButtonReSend_Click(object sender, EventArgs e)
    {
        SendHelper.SendOrder(order);
        repo.Context.SaveChanges();
        Response.Redirect(Request.RawUrl);
    }

    protected void ButtonEdit_Click(object sender, EventArgs e)
    {
        Session["Order"] = order;
        Response.Redirect("/products/product.aspx");
    }
}