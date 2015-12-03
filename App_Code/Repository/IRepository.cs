using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// IRepository 的摘要说明
/// </summary>
public interface IRepository
{
    UK_ExpressEntities Context
    {
        get;
    }

    IEnumerable<SheffieldService> SheffieldServices
    {
        get;
    }

    IEnumerable<SheffieldOrder> SheffieldOrders
    {
        get;
    }

    IEnumerable<Service> Services
    {
        get;
    }

    IEnumerable<Recipient> Recipients
    {
        get;
    }

    IEnumerable<Order> Orders
    {
        get;
    }

    IEnumerable<Reinforce> Reinforces
    {
        get;
    }

    IEnumerable<PriceList> PriceLists
    {
        get;
    }

    void SaveOrder(Order order);

    void SaveRecipient(Recipient recipient);
   
}