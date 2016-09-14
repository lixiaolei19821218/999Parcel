using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class cart_OrderDetail : System.Web.UI.Page
{
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
            int id;
            Order order;
            if (int.TryParse(Session["id"].ToString(), out id))
            {
                order = repo.Context.Orders.Find(id);
            }
            else
            {
                order = new Order();
            }
            return order;
        }
    }

    public string GetPickupTime(Order o)
    {
        if (o.Service.PickUpCompany.Trim() == "999Parcel")
        {
            if (o.PickupTime.Value.Hour < 12)
            {
                return o.PickupTime.Value.ToShortDateString() + " AM";
            }
            else
            {
                return o.PickupTime.Value.ToShortDateString() + " PM";
            }
        }
        else
        {
            return o.PickupTime.Value.ToShortDateString();
        }
    }

    public string GetPacakgeDetail(Package p)
    {
        if (p.Recipient.Order.HasPaid ?? false)
        {
            if (p.Recipient.Order.Service.Name.Contains("Parcelforce"))
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
}