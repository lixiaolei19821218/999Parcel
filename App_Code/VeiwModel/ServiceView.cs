using System;
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
                    price += order.Reinforce.Price.HasValue ? order.Reinforce.Price.Value : 0.0m;
                }
            }
        }

        return price;
    }

    public decimal GetPickupPrice(Order order)
    {
        decimal price = 0m;
        
        switch (Id)
        {
            case 1://Bpost免费取件
            case 11://post nl免费取件
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
                        string head = temp[0];
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
            case 15://Parcelforce
            case 17://Parcelforce
            case 23://Parcelforce
            case 25://Parcelforce
            case 27://Parcelforce
                price = 0m;
                break;
            case 6://Bpost UKMail取件
            case 12://post nl免 UKMail取件
                //ukmail取件费用，单箱5镑，2-3箱7镑，4箱以上每箱2镑的
                //2015-6-16改为单想5镑，两箱7镑，三箱或以上免费
                int packageCount = order.Recipients.Sum(r => r.Packages.Count);
                if (packageCount == 1)
                {
                    price = 5m;
                }
                else if (packageCount == 2)
                {
                    price = 7m;
                }
                else
                {
                    price = 0m;
                }                
                break;
            case 32://Bpost - DPD 取件      
                packageCount = order.Recipients.Sum(r => r.Packages.Count);
                price = 5m * packageCount;
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