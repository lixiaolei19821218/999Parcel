using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class cart_SheffieldOrderDetail : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo
    {
        get;
        set;
    }

    public Recipient Recipient
    {
        get
        {
            return Order.Recipients.First();
        }
    }

    public Order Order
    {
        get
        {
            return sheffieldOrder.Orders.First();
        }
    }

    public SheffieldOrder SheffieldOrder
    {
        get
        {
            return sheffieldOrder;
        }
    }

    private SheffieldOrder sheffieldOrder;

    public IEnumerable<Order> GetOrders()
    {
        return sheffieldOrder.Orders;
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
            sheffieldOrder = repo.Context.SheffieldOrders.Find(id);
        }
        if (sheffieldOrder == null)
        {
            Response.Redirect("/");
        }
    }

    public string GetPacakgeDetail(Package p)
    {
        if (p.Recipient.Order.Service.Name.Contains("Parcelforce"))
        {
            return (p.Status == "SUCCESS") ? "<a href=\"/" + p.Pdf + "\">点击下载</a>" : "<a title=\"错误信息\" class=\"btn-link\" data-container=\"body\" data-toggle=\"popover\" data-placement=\"right\" data-content=\"" + p.Response + "\">错误详情</a>";
        }
        else//bpost
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
    }

    public string FormatPackageItems(Package package)
    {
        StringBuilder sb = new StringBuilder();
        foreach (PackageItem item in package.PackageItems)
        {
            string line = string.Format("{0} &times; {1}， 总价：{2}<br/>", item.Description, item.Count, item.Value);
            sb.Append(line);
        }
        return sb.ToString();
    }
}