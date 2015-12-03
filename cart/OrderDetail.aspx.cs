using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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

    private Order order;
    private ServiceView sv;

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
        if (order == null)
        {
            Response.Redirect("/");
        }
        Service service = repo.Services.FirstOrDefault(s => s.Id == order.ServiceID);
        sv = new ServiceView(service);
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

    public decimal GetPackagePrice(Package package)
    {
        return sv.GetPackageDeliverPrice(package);
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

    public string GetStatus(Recipient r)
    {
        if (r.Order.Service.Name.Contains("Parcelforce"))
        {
            return (r.SuccessPaid ?? false) ? "<div style=\"float:right;font-size:medium;color:green;\">发送成功</div>" : "<div style=\"float:right;font-size:medium;color:red;\">发送失败</div>";
        }
        else//bpost
        {
            if (r.SuccessPaid.HasValue)
            {
                if (r.SuccessPaid.Value)
                {
                    return "<div style=\"float:right;font-size:medium;color:green;\">发送成功</div>";
                }
                else
                {
                    return "<div style=\"float:right;font-size:medium;color:red;\">发送失败</div>";
                }
            }
            else
            {
                return "<div style=\"float:right;font-size:medium;color:lightblue;\">已发送到Bpost，等待返回信息</div>";
            }            
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
                return "<a title=\"已发送Bpost\" class=\"btn-link\" data-container=\"body\" data-toggle=\"popover\" data-placement=\"right\" data-content=\"" + "等待Bpost返回结果" + "\">已发送Bpost</a>";
            }    
        }
    }
}