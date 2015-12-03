using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Repository 的摘要说明
/// </summary>
public class Repository : IRepository
{
    private UK_ExpressEntities context = new UK_ExpressEntities(); 
	public Repository()
	{
		//
		// TODO: 在此处添加构造函数逻辑
        //        
	}

    public UK_ExpressEntities Context
    {
        get
        {
            return context;
        }
    }

    public IEnumerable<SheffieldService> SheffieldServices
    {
        get
        {
            return context.SheffieldServices;
        }
    }

    public IEnumerable<SheffieldOrder> SheffieldOrders
    {
        get
        {
            return context.SheffieldOrders;
        }
    }

    public IEnumerable<Service> Services
    {
        get
        {
            return context.Services;
        }
    }

    public IEnumerable<Recipient> Recipients
    {
        get
        {
            return context.Recipients;
        }
    }

    public IEnumerable<Order> Orders
    {
        get
        {
            return context.Orders;
        }
    }

    public IEnumerable<Reinforce> Reinforces
    {
        get
        {
            return context.Reinforces;
        }
    }

    public IEnumerable<PriceList> PriceLists
    {
        get
        {
            return context.PriceLists;
        }
    }

    public void SaveOrder(Order order)
    {
        if (order.Id == 0)
        {
            order = context.Orders.Add(order);            
        }
        else
        {
            Order dbOrder = context.Orders.Find(order.Id);
            if (dbOrder != null)
            {
                dbOrder.IsValid = order.IsValid;
                dbOrder.HasPaid = order.HasPaid;
                dbOrder.OrderTime = order.OrderTime;
                dbOrder.PickupTime = order.PickupTime;
                //dbOrder.Recipients = order.Recipients;
                //dbOrder.Sender = order.Sender;
                //dbOrder.SenderId = order.SenderId;
                //dbOrder.Service = order.Service;
                //dbOrder.ServiceID = order.ServiceID;
                dbOrder.User = order.User;
            }
        }
        context.SaveChanges();
    }

    public void SaveRecipient(Recipient recipient)
    {
        if (recipient.Id == 0)
        {
            recipient = context.Recipients.Add(recipient);
        }        
        context.SaveChanges();
    }
}