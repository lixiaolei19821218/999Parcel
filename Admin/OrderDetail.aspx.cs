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
}