using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.Web.Security;
using System.Web.Services;
using System.Configuration;
using System.Text;

public partial class products_Product : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    private ServiceView sv;
    private Order order;

    protected void Page_Load(object sender, EventArgs e)
    {
        order = (Order)Session["Order"];
        if (order == null)
        {
            Response.Redirect("/");
        }

        Service service = repo.Services.FirstOrDefault(s => s.Id == order.ServiceID);
        sv = new ServiceView(service);
        //order.Service = service;

        //ParcelForce
        if (sv.Name.Contains("Parcelforce"))
        {
            add2cart.Text = "添加到购物车";
        }

        //根据用户选取的服务，确定不同的取件时间
        if (sv.Name.Contains("Parcelforce") || sv.Name.Contains("UKMail"))
        {
            pfuk.Visible = true;
            _999parcel.Visible = false;
        }
        else
        {
            pfuk.Visible = false;
            _999parcel.Visible = true;            
        }       
    }

    public IEnumerable<Recipient> GetRecipients()
    {
        foreach (Recipient r in order.Recipients)
        {
            foreach (Package p in r.Packages)
            {
               if (p.PackageItems.Count == 0)
               {
                   p.PackageItems.Add(new PackageItem() { Description = "Baby Milk Powder" });
               }
            }
        }
        return order.Recipients;
    }

    public decimal GetSendPrice()
    {
        return sv.GetSendPrice(order);
    }
    protected void add2cart_Click(object sender, EventArgs e)
    {
        string msg = FillOrder();
        if (msg == "pass")
        {
            if (order.Id == 0)
            {
                order.User = Membership.GetUser().UserName;
                order.OrderTime = DateTime.Now;
                order.Cost = sv.GetSendPrice(order);
                repo.Context.Orders.Add(order);             
            }
            else
            {
                Order old = repo.Context.Orders.Find(order.Id);

                foreach (Recipient r in old.Recipients)
                {
                    foreach (Package p in r.Packages)
                    {
                        repo.Context.PackageItems.RemoveRange(p.PackageItems);
                    }
                    repo.Context.Packages.RemoveRange(r.Packages);
                }
                repo.Context.Recipients.RemoveRange(old.Recipients);

                old.HasPaid = order.HasPaid;
                old.IsValid = order.IsValid;
                old.OrderTime = order.OrderTime;
                old.PickupTime = order.PickupTime;
                old.SenderAddress1 = order.SenderAddress1;
                old.SenderAddress2 = order.SenderAddress2;
                old.SenderAddress3 = order.SenderAddress3;
                old.SenderCity = order.SenderCity;
                old.SenderName = order.SenderName;
                old.SenderPhone = order.SenderPhone;
                old.SenderZipCode = order.SenderZipCode;
                foreach (Recipient r in order.Recipients)
                {
                    old.Recipients.Add(r);
                }
                old.Cost = sv.GetSendPrice(old);
            }

            repo.Context.SaveChanges();

            //ParcelForce
            if (sv.Name.Contains("Parcelforce"))
            {

                Response.Redirect("/cart/cart.aspx");
            }
            else
            {
                Response.Redirect("/products/reinforce.aspx");
            }
        }
        else
        {
            LabelError.Visible = true;
            LabelError.Text = msg;
        }
    }

    public IEnumerable<Package> GetAllPackages()
    {
        List<Package> packages = new List<Package>();
        foreach (Recipient r in order.Recipients)
        {
            packages.AddRange(r.Packages);
        }

        return packages;
    }

    public decimal GetPackagePrice(Package package)
    {
        return sv.GetPackageDeliverPrice(package);
    }

    public ServiceView ServiceView
    {
        get
        {
            return sv;
        }
    }

    public IEnumerable<Recipient> Recipients
    {
        get
        {
            return order.Recipients;
        }
    }

    public Order Order
    {
        get
        {
            return order;
        }
    }
    protected void LinkButtonEdit_Click(object sender, EventArgs e)
    {
        FillOrder();
        Response.Redirect("/products/edit.aspx");
    }

    public string FillOrder()
    {
        order.SenderName = Request.Form.Get("billing_detail_name").Trim();
        order.SenderCity = Request.Form.Get("billing_detail_city").Trim();
        order.SenderPhone = Request.Form.Get("billing_detail_phone").Trim();
        order.SenderAddress1 = Request.Form.Get("billing_detail_street").Trim();
        order.SenderAddress2 = Request.Form.Get("billing_detail_street2").Trim();
        order.SenderAddress3 = Request.Form.Get("billing_detail_street3").Trim();
        order.SenderZipCode = Request.Form.Get("billing_detail_postcode").Trim();

        List<Recipient> recipientList = order.Recipients.ToList();
        for (int i = 0; i < recipientList.Count; i++)
        {
            Recipient recipient = recipientList[i];
            recipient.Name = Request.Form.Get(string.Format("addr-{0}-cn_name", i)).Trim();
            recipient.City = Request.Form.Get(string.Format("addr-{0}-cn_city", i)).Trim();
            recipient.Address = Request.Form.Get(string.Format("addr-{0}-cn_street", i)).Trim();
            recipient.PhoneNumber = Request.Form.Get(string.Format("addr-{0}-phone", i)).Trim();
            recipient.ZipCode = Request.Form.Get(string.Format("addr-{0}-postcode", i)).Trim();
            recipient.PyName = Request.Form.Get(string.Format("hd_name{0}", i)).Trim();
            recipient.PyCity = Request.Form.Get(string.Format("hd_city{0}", i)).Trim();
            recipient.PyAddress = Request.Form.Get(string.Format("hd_street{0}", i)).Trim();
            if (recipient.PyAddress.Length > 72)
            {
                return string.Format("收件人{0}的拼音地址超出72个字符", recipient.Name);
            }
        }
        List<Package> packages = new List<Package>();
        foreach (Recipient r in order.Recipients)
        {
            packages.AddRange(r.Packages);
        }
        for (int i = 0; i < packages.Count; i++)
        {            
            int itemsCount = int.Parse(Request.Form.Get(string.Format("parcel-{0}-content-TOTAL_FORMS", i)));
            decimal weight = packages[i].Weight / itemsCount;
            packages[i].PackageItems.Clear();
            for (int j = 0; j < itemsCount; j++)
            {
                PackageItem item = new PackageItem();
                item.Description = Request.Form.Get(string.Format("parcel-{0}-content-{1}-type", i, j)).Trim();
                item.TariffCode = "999999";
                item.Count = int.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-quantity", i, j)));
                decimal unitPrice = decimal.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-cost", i, j)));
                item.Value = Math.Round(unitPrice * (decimal)item.Count, 2);
                item.NettoWeight = Math.Round(weight, 3);                
                packages[i].PackageItems.Add(item);
            }
            packages[i].Value = packages[i].PackageItems.Sum(pi => pi.Value);
        }

        DateTime date;
        if (DateTime.TryParse(Request["pickup_time_0"], out date))
        {
            order.PickupTime = date;
        }
        else
        {
            return "请输入取件时间";
        }

        if (string.IsNullOrEmpty(order.SenderName))
        {
            return "请输入发件人的姓名";
        }
        else if (string.IsNullOrEmpty(order.SenderCity))
        {
            return "请输入发件人的城市";
        }
        else if (string.IsNullOrEmpty(order.SenderAddress1))
        {
            return "请输入发件人的地址";
        }
        else if (string.IsNullOrEmpty(order.SenderZipCode))
        {
            return "请输入发件人的邮编";
        }
        else if (string.IsNullOrEmpty(order.SenderPhone))
        {
            return "请输入发件人的电话";
        }

        for (int i = 0; i < recipientList.Count; i++)
        {
            Recipient r = recipientList[i];
            if (string.IsNullOrEmpty(r.Name))
            {
                return string.Format("请输入收件人{0}的姓名", i + 1);
            }
            else if (string.IsNullOrEmpty(r.City))
            {
                return string.Format("请输入收件人{0}的城市", i + 1);
            }
            else if (string.IsNullOrEmpty(r.Address))
            {
                return string.Format("请输入收件人{0}的地址", i + 1);
            }
            else if (string.IsNullOrEmpty(r.ZipCode))
            {
                return string.Format("请输入收件人{0}的邮编", i + 1);
            }
            else if (string.IsNullOrEmpty(r.PhoneNumber))
            {
                return string.Format("请输入收件人{0}的电话", i + 1);
            }
        }

        return "pass";
    }    
    
    public string FreeAreas
    {
        get
        {
            return ConfigurationManager.AppSettings["_999ParcelFreeAreas"];
        }
    }

    public string ChargedAreas
    {
        get
        {            
            return ConfigurationManager.AppSettings["_999ParcelChargeAreas"];
        }
    }

    public decimal ChargePrice
    {
        get
        {
            return decimal.Parse(ConfigurationManager.AppSettings["_999ParcelChargePrice"]);
        }
    }

    public string GetDetails()
    {
        StringBuilder sb = new StringBuilder();
        foreach (Recipient r in order.Recipients)
        {
            foreach (Package p in r.Packages)
            {               
                foreach (PackageItem i in p.PackageItems)
                {
                    sb.Append(string.Format("'{0}',", i.Description));
                }
            }
        }
        sb.Remove(sb.Length - 1, 1);
        return sb.ToString();
    }
}