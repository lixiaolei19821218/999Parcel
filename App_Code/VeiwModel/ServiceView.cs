﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

/// <summary>
/// ServiceView 的摘要说明
/// </summary>
public class ServiceView
{
    [Ninject.Inject]
    public IRepository repo
    {
        get;
        set;
    }

    public int Id { get; set; }
    public string Name { get; set; }
    public string PictureLink { get; set; }
    public string Discribe { get; set; }
    public string DiscribePictureLink { get; set; }
    public bool PickUpService { get; set; }
    public Nullable<int> PriceListID { get; set; }
    public string PickUpCompany { get; set; }
    public virtual PriceList PriceList { get; set; }

	public ServiceView()
	{
		//
		// TODO: 在此处添加构造函数逻辑
		//
	}

    public ServiceView(Service service)
    {
        this.Id = service.Id;
        this.Name = service.Name;
        this.PictureLink = service.PictureLink;
        this.Discribe = service.Discribe;
        this.DiscribePictureLink = service.DiscribePictureLink;
        this.PriceListID = service.PriceListID;
        this.PickUpCompany = service.PickUpCompany;
        this.PriceList = service.PriceList;         
    }    

    /// <summary>
    /// 上门取件费 + 快递费 + 加固费
    /// </summary>
    /// <param name="order"></param>
    /// <returns></returns>
    public decimal GetPrice(Order order)
    {
        return GetReinforcePrice(order) + GetPickupPrice(order) + GetDeliverPrice(order);
    }

    /// <summary>
    /// 上门取件费 + 快递费
    /// </summary>
    /// <param name="order"></param>
    /// <returns></returns>
    public decimal GetSendPrice(Order order)
    {
        return GetPickupPrice(order) + GetDeliverPrice(order);
    }

    public decimal GetReinforcePrice(Order order)
    {
        decimal price = 0m;

        if (order.ReinforceID.HasValue)
        {
            foreach (Recipient r in order.Recipients)
            {
                foreach (Package p in r.Packages)
                {
                    //p.ReinforceCost = order.Reinforce.Price.HasValue ? order.Reinforce.Price.Value : 0.0m;
                    price += order.Reinforce.Price.HasValue ? order.Reinforce.Price.Value : 0.0m;
                }
            }
        }

        return price;
    }

    public decimal GetPickupPrice(Order order)
    {
        decimal price = 0m;
        
        switch (Name)
        {
            case "Bpost - 诚信物流取件"://Bpost 999Parcel取件
            case "荷兰邮政 - 免费取件"://post nl 999Parcel免费取件
                if (string.IsNullOrEmpty(order.SenderZipCode))
                {
                    price = 0m;
                }
                else
                {
                    //zip code should like S9 2Hr
                    string[] temp = order.SenderZipCode.Split(new char[]{' ', '\t'}, StringSplitOptions.RemoveEmptyEntries);
                    if (temp.Length == 2)
                    {
                        string head = temp[0].ToUpper();
                        string freeAreas = ConfigurationManager.AppSettings["_999ParcelFreeAreas"];
                        if (freeAreas.Contains(head))
                        {
                            price = 0.0m;
                        }
                        else
                        {
                            string chargedAreas = ConfigurationManager.AppSettings["_999ParcelChargeAreas"]; ;
                            decimal chargedPrice = decimal.Parse(ConfigurationManager.AppSettings["_999ParcelChargePrice"]);
                            if (chargedAreas.Contains(head))
                            {
                                price = chargedPrice;
                            }
                            else
                            {
                                throw new Exception("非诚信物流取件的邮政编码");
                            }
                        }
                    }
                }
                break;
            case "Parcelforce Economy - 上门取件"://Parcelforce
            case "Parcelforce Priority - 上门取件"://Parcelforce
            case "Parcelforce Economy - 自送Depot"://Parcelforce
            case "Parcelforce Economy - 自送邮局"://Parcelforce
            case "Parcelforce Priority - 自送邮局"://Parcelforce
            case "Parcelforce Economy - 自送仓库"://Parcelforce
            case "Parcelforce Priority 小包裹 - 自送仓库"://Parcelforce
            case "Parcelforce Luggage 大行李专线"://Parcelforce
            case "Parcelforce Child Car Seat 儿童安全座椅专线 - 自送仓库"://Parcelforce
                price = 0m;
                break;
            case "Parcelforce Economy - 诚信物流取件":
            case "Parcelforce Priority 小包裹 - 诚信物流取件":
            case "Parcelforce Child Car Seat 儿童安全座椅专线 - 诚信物流取件":
                price = decimal.Parse(ConfigurationManager.AppSettings["pickupPrice"]);
                break;
            case "Bpost - UKMail 取件"://Bpost UKMail取件
            case "荷兰邮政 - UKMail 取件"://post nl UKMail取件
                //ukmail取件费用，单箱5镑，2-3箱7镑，4箱以上每箱2镑的
                //2015-6-16改为单箱5镑，两箱7镑，三箱或以上免费
                //2016-03-08改为ukmail取件单箱加10镑 2-3箱加8镑 4-6箱加6镑 7-9箱加4镑 10箱以上加3镑
                int packageCount = order.Recipients.Sum(r => r.Packages.Count);
                if (packageCount == 1)
                {
                    price = 10m;
                }
                else if (packageCount == 2 || packageCount == 3)
                {
                    price = 8m;
                }
                else if (packageCount >= 4 && packageCount <= 6)
                {
                    price = 6;
                }
                else
                {
                    price = 3m;
                }                
                break;
            case "Bpost - DPD 取件"://Bpost - DPD 取件      
                packageCount = order.Recipients.Sum(r => r.Packages.Count);
                price = 5m * packageCount;
                break;
            case "Bpost - 自送仓库"://Bpost - 自送仓库
                price = 0m;
                break;
                //bpost 奶粉专线
            case "奶粉包税专线 - 诚信物流取件":
                price = 3m;
                break;
            case "奶粉包税专线 - 自送仓库":
                price = 0m;
                break;
                //杂物包税
            case "杂物包税专线（100镑以内） - 自送仓库":
                price = 0m;
                break;
            case "杂物包税专线（100镑以内） - 诚信物流取件":
                price = decimal.Parse(ConfigurationManager.AppSettings["_999ParcelChargePrice"]);
                break;
            case "杂物包税专线（200镑以内） - 自送仓库":
                price = 0m;
                break;
            case "杂物包税专线（200镑以内） - 诚信物流取件":
                price = decimal.Parse(ConfigurationManager.AppSettings["_999ParcelChargePrice"]);
                break;
            case "自营奶粉包税4罐 - 自送仓库":
            case "自营奶粉包税6罐 - 自送仓库":
                price = 0m;
                break;
            case "自营奶粉包税4罐 - 诚信物流取件"://自营4罐奶粉
            case "自营奶粉包税6罐 - 诚信物流取件"://自营6罐奶粉    
            case "顺丰奶粉包税4罐 - 诚信物流取件"://顺丰4罐奶粉
            case "顺丰奶粉包税6罐 - 诚信物流取件"://顺丰6罐奶粉                   
                packageCount = order.Recipients.Sum(r => r.Packages.Count);
                
                if (packageCount < 3)
                {
                    price = decimal.Parse(ConfigurationManager.AppSettings["pickupPrice"]) * packageCount;
                }
                else
                {
                    price = 0m;
                }
                
                //price = 2m * packageCount;//到cart统一算折扣
                break;
            default:
                price = 0m;
                break;
        }

        return Math.Round(price, 2);
    }

    public decimal GetDeliverPrice(Order order)
    {
        decimal price = 0m;

        foreach (Recipient r in order.Recipients)
        {
            foreach (Package p in r.Packages)
            {
                //p.DeliverCost = GetPackageDeliverPrice(p);
                //price += p.DeliverCost;
                price += GetPackageDeliverPrice(p);
            }
        }        
        
        return price;
    }

    public decimal GetPackageDeliverPrice(Package package)
    {
        PriceListView pv = new PriceListView(PriceList);
        return pv.GetPackageDeliverPrice(package);        
    }

    public decimal GetPackagesDeliverPrice(IEnumerable<Package> packages)
    {
        return packages.Sum(p => GetPackageDeliverPrice(p));
    }
}