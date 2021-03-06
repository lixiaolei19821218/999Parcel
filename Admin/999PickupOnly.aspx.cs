﻿using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_CheckOrder : System.Web.UI.Page
{
    private int pageSize = 20;

    private IEnumerable<Order> normalOrders;
    
    [Ninject.Inject]
    public IRepository repo
    {
        get;
        set;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string content = Request.QueryString["content"];
        if (content == null)
        {
            normalOrders = from o in repo.Orders where (o.Service != null && (o.HasPaid ?? false) && o.Service.Name.Contains("诚信物流取件")) select o;
        }
        else
        {           
            int id;
            if (int.TryParse(content, out id))
            {
                normalOrders = repo.Orders.Where(o => o.Id == id);
            }
            else
            {
                normalOrders = repo.Orders.Where(o => o.User == content);
            }                
        }      
    }

    public IEnumerable<Order> GetNoneSheffieldOrders()
    {
        return normalOrders;
    }
    /*
    public IEnumerable<SheffieldOrder> GetSheffieldOrders()
    {
        return sheffieldOrders;
    }*/

    public string GetOrderTip(Order order)
    {
        ServiceView sv = new ServiceView(order.Service);
        Thread.CurrentThread.CurrentCulture = new CultureInfo("en-gb");
        return string.Format("取件费：{0:c2}，加固费：{1:c2}，快递费：{2:c2}", sv.GetPickupPrice(order), sv.GetReinforcePrice(order), sv.GetDeliverPrice(order));
    }
    protected void NormalDetail_Click(object sender, EventArgs e)
    {
        int id;
        if (int.TryParse((sender as LinkButton).Attributes["data-id"], out id))
        {
            Session.Add("id", id);
            Response.Redirect("/admin/OrderDetail.aspx");
        }
    }

    public IEnumerable<Order> GetPageApplys()
    {
        return normalOrders.OrderByDescending(p => p.Id).Skip((CurrentPage - 1) * pageSize).Take(pageSize);
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
            if (normalOrders.Count() == 0)
            {
                return 1;
            }
            else
            {
                return (int)Math.Ceiling((decimal)normalOrders.Count() / pageSize);
            };
        }
    }
    
    protected void FindOrder_Click(object sender, EventArgs e)
    {
        string content = Request.Form.Get("content");
        Response.Redirect(string.Format("/admin/CheckOrder.aspx?content={0}", content));
    }

    public string GetStatus(Order o)
    {
        if (o.HasPaid ?? false)
        {
            return (o.SuccessPaid.HasValue && o.SuccessPaid.Value) ? "<img src=\"../static/images/icon/onCorrect.gif\" title=\"发送成功\">" : "<img src=\"../static/images/icon/onFocus.gif\" title=\"有发送失败的包裹\">";
        }
        else
        {
            return "<img src=\"../static/images/icon/onFocus.gif\" title=\"未付款\">";
        }
    }
}