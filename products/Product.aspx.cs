﻿using System;
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
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NPinyin;
using Microsoft.VisualBasic;

public partial class products_Product : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    private ServiceView sv;
    private Order order;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.Timeout = 6000;

        order = (Order)Session["Order"];
       
        if (order == null)
        {
            int orderId;
            if (int.TryParse(Request["orderId"], out orderId))
            {
                order = repo.Context.Orders.Find(orderId);
                if (order == null)
                {
                    Response.Redirect("/");
                }
            }
            else
            {
                /*
                if (Request.Cookies["Order"] == null)
                {
                    Response.Redirect("/");
                }
                else
                {
                    string orderString = Request.Cookies["Order"].Value;
                    order = JsonConvert.DeserializeObject<Order>(orderString);
                }
                */
                int serviceId;
                if (int.TryParse(Request["serviceId"], out serviceId))
                {
                    Service service = repo.Context.Services.FirstOrDefault(s => s.Id == serviceId);                    
                    if (service == null)
                    {
                        Response.Redirect("/");
                    }
                    order = new Order();
                    order.ServiceID = serviceId;
                    order.Service = service;
                }
                else
                {
                    Response.Redirect("/");
                }
            }
        }

        sv = new ServiceView(order.Service);
        //ParcelForce
        if (sv.Name.Contains("Parcelforce"))
        {
            //add2cart.Text = "添加到购物车";
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

        //Fill Sender
        if (!IsPostBack)
        {
            if (order.Id == 0)
            {
                string username = Membership.GetUser().UserName;
                aspnet_User user = repo.Context.aspnet_User.FirstOrDefault(u => u.UserName == username);
                repo.Context.Entry<aspnet_User>(user).Reload();                
                if (user.DefaultSender != null)
                {
                    repo.Context.Entry<DefaultSender>(user.DefaultSender).Reload();
                    id_billing_detail_name.Value = user.DefaultSender.Name;
                    id_billing_detail_city.Value = user.DefaultSender.City;
                    id_billing_detail_email.Value = user.DefaultSender.Mail;
                    id_billing_detail_phone.Value = user.DefaultSender.Phone;
                    id_billing_detail_postcode.Value = user.DefaultSender.ZipCode;
                    id_billing_detail_street.Value = user.DefaultSender.Address1;
                    id_billing_detail_street2.Value = user.DefaultSender.Address2;
                    id_billing_detail_street3.Value = user.DefaultSender.Address3;
                }
            }
            else
            {
                id_billing_detail_name.Value = order.SenderName;
                id_billing_detail_city.Value = order.SenderCity;
                id_billing_detail_email.Value = order.SenderEmail;
                id_billing_detail_phone.Value = order.SenderPhone;
                id_billing_detail_postcode.Value = order.SenderZipCode;
                id_billing_detail_street.Value = order.SenderAddress1;
                id_billing_detail_street2.Value = order.SenderAddress2;
                id_billing_detail_street3.Value = order.SenderAddress3;
            }
        }
    }   

    public string GetVisibility()
    {
        if (order.SuccessPaid == false)
        {
            return "style = \"visibility:collapse;\"";
        }
        else
        {
            return string.Empty;
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
        return order.Recipients.Where(r => r.SuccessPaid.HasValue == false || r.SuccessPaid == false);
    }

    public decimal GetSendPrice()
    {
        return order.PickupPrice + order.DeliverPrice - order.Discount;
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

            if (order.Id != 0 && order.SuccessPaid == false)
            {
                repo.Context.SaveChanges();
                Session.Add("id", order.Id);
                Response.Redirect("/cart/OrderDetail.aspx");
            }

            order.PickupPrice = sv.GetPickupPrice(order);
            foreach (Recipient r in order.Recipients)
            {
                foreach (Package p in r.Packages)
                {
                    p.DeliverCost = sv.GetPackageDeliverPrice(p);
                    p.FinalCost = p.DeliverCost;
                }
            }
            order.DeliverPrice = sv.GetDeliverPrice(order);

            //计算折扣
            MembershipUser user = Membership.GetUser();
            var discount = repo.Context.Discounts.Where(d => d.User == user.UserName && d.ServiceId == order.ServiceID).FirstOrDefault();
            if (discount != null)
            {
                repo.Context.Entry<Discount>(discount).Reload();
                foreach (Recipient r in order.Recipients)
                {
                    foreach (Package p in r.Packages)
                    {
                        p.Discount = discount.Value;
                        p.FinalCost = p.DeliverCost - p.Discount;
                    }
                }
            }
            order.Discount = order.Recipients.Sum(r => r.Packages.Sum(p => p.Discount));
            order.Cost = order.PickupPrice + order.DeliverPrice - order.Discount;

            repo.Context.SaveChanges();

            //ParcelForce
            if (sv.Name.Contains("Parcelforce") || sv.Name.Contains("奶粉包税"))
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
            foreach (Recipient r in order.Recipients)
            {
                foreach (Package p in r.Packages)
                {
                    p.DeliverCost = sv.GetPackageDeliverPrice(p);
                    p.FinalCost = p.DeliverCost;
                }
            }
            order.DeliverPrice = sv.GetDeliverPrice(order);

            //计算折扣
            MembershipUser user = Membership.GetUser();
            var discount = repo.Context.Discounts.Where(d => d.User == user.UserName && d.ServiceId == order.ServiceID).FirstOrDefault();
            if (discount != null)
            {
                repo.Context.Entry<Discount>(discount).Reload();
                foreach (Recipient r in order.Recipients)
                {
                    foreach (Package p in r.Packages)
                    {
                        p.Discount = discount.Value;
                        p.FinalCost = p.DeliverCost - p.Discount;
                    }
                }
            }
            order.Discount = order.Recipients.Sum(r => r.Packages.Sum(p => p.Discount));
            order.Cost = order.PickupPrice + order.DeliverPrice - order.Discount;
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
        StringBuilder msg = new StringBuilder();
        order.SenderName = id_billing_detail_name.Value.Trim();
        order.SenderCity = id_billing_detail_city.Value.Trim();
        order.SenderPhone = id_billing_detail_phone.Value.Trim();
        if (order.SenderPhone.Length != 11)
        {
            msg.Append("请输入11位电话号码。");
        }
        order.SenderAddress1 = id_billing_detail_street.Value.Trim();
        order.SenderAddress2 = id_billing_detail_street2.Value.Trim();
        order.SenderAddress3 = id_billing_detail_street3.Value.Trim();
        order.SenderZipCode = id_billing_detail_postcode.Value.Trim();
        order.SenderEmail = id_billing_detail_email.Value.Trim();

        if (order.Id == 0)
        {
            order.Recipients.Clear();
        }
        else
        {
            if (order.SuccessPaid == null)
            {
                foreach (Recipient r in order.Recipients)
                {
                    foreach (Package p in r.Packages)
                    {
                        repo.Context.PackageItems.RemoveRange(p.PackageItems);
                    }
                    repo.Context.Packages.RemoveRange(r.Packages);
                }
                repo.Context.Recipients.RemoveRange(order.Recipients);
                order.Recipients.Clear();
            }
            else if (order.SuccessPaid == false)
            {

            }
        }

       
        int recipientCount = int.Parse(Request.Form.Get("addr-TOTAL_FORMS"));
        for (int i = 0; i < recipientCount; i++)
        {
            Recipient recipient;
            if (order.SuccessPaid == false)
            {
                recipient = order.Recipients.ElementAt(i);
            }
            else
            {
                recipient = new Recipient();
                order.Recipients.Add(recipient);
            }
            
            recipient.Name = Request.Form.Get(string.Format("addr-{0}-cn_name", i)).Trim();
            recipient.PyName = Pinyin.GetPinyin(recipient.Name);
            recipient.PyName = SendHelper.DeleteChineseWord(recipient.PyName);

            recipient.Province = Request.Form.Get(string.Format("addr-{0}-cn_province", i)).Trim();
            recipient.PyProvince = Pinyin.GetPinyin(recipient.Province);
            if (recipient.Province == "北京市" || recipient.Province == "天津市" || recipient.Province == "上海市" || recipient.Province == "重庆市")
            {
                //recipient.City = Request.Form.Get(string.Format("addr-{0}-cn_district", i)).Trim();
                //recipient.PyCity = Pinyin.GetPinyin(recipient.City);
                recipient.City = recipient.Province;
            }
            else
            {
                recipient.City = Request.Form.Get(string.Format("addr-{0}-cn_city", i)).Trim();
            }
            recipient.District = Request.Form.Get(string.Format("addr-{0}-cn_district", i)).Trim();
            recipient.PyCity = Pinyin.GetPinyin(recipient.City);
            recipient.PyDistrict = Pinyin.GetPinyin(recipient.District);
            if (string.IsNullOrEmpty(recipient.District))
            {
                recipient.District = " ";
            }

            recipient.Address = Request.Form.Get(string.Format("addr-{0}-cn_street", i)).Trim();
            recipient.Address = recipient.Address.Replace("（", "(");
            recipient.Address = recipient.Address.Replace("）", ")");
            recipient.Address = recipient.Address.Replace("，", ",");
            recipient.Address = recipient.Address.Replace("—", "-");
            recipient.Address = recipient.Address.Replace("－", "-");
            string temp = Strings.StrConv(recipient.Address.Replace(" ", ""), VbStrConv.SimplifiedChinese, 0);
            temp = temp.Replace("?", "");
            temp = Pinyin.GetPinyin(temp);
            recipient.PyAddress = SendHelper.DeleteChineseWord(temp);
            recipient.PhoneNumber = Request.Form.Get(string.Format("addr-{0}-phone", i)).Trim();
            recipient.ZipCode = Request.Form.Get(string.Format("addr-{0}-postcode", i)).Trim();           
            recipient.IDNumber = Request.Form.Get(string.Format("addr-{0}-idnumber", i)).Trim();

            if (order.Service.Name.Contains("奶粉包税") || order.Service.Name.Contains("杂物包税"))
            {
                if (CheckIDNumber(recipient.Name, recipient.IDNumber) == "验证失败")
                {
                    msg.Append(string.Format("收件人{0}的名字和身份证号不匹配。", recipient.Name));
                }
            }           
        }

        if (order.SuccessPaid == null)//fail paid order can't modify packages
        {
            int parcelCount = int.Parse(Request.Form.Get("parcel-TOTAL_FORMS"));
            int weight = order.Service.Name.Contains("奶粉包税6罐") ? 7 : 5;
            for (int j = 0; j < parcelCount; j++)
            {
                int recipientNum = int.Parse(Request.Form.Get(string.Format("parcel-{0}-address_id", j)));
                Package p;
                if (order.Service.Name.Contains("奶粉包税"))
                {
                    p = new Package() { Weight = weight, Length = 1, Width = 1, Height = 1 };
                }
                else
                {
                    p = new Package()
                    {
                        Weight = decimal.Parse(Request.Form.Get(string.Format("parcel-{0}-weight", j))),
                        Length = decimal.Parse(Request.Form.Get(string.Format("parcel-{0}-length", j))),
                        Width = decimal.Parse(Request.Form.Get(string.Format("parcel-{0}-width", j))),
                        Height = decimal.Parse(Request.Form.Get(string.Format("parcel-{0}-height", j))),
                    };
                }
                order.Recipients.ElementAt(recipientNum).Packages.Add(p);
                int itemsCount = int.Parse(Request.Form.Get(string.Format("parcel-{0}-content-TOTAL_FORMS", j)));
                for (int k = 0; k < itemsCount; k++)
                {
                    PackageItem pi = new PackageItem();

                    //pi.Description = Request.Form.Get(string.Format("parcel-{0}-content-{1}-description", j, k)).Trim();
                    //pi.Brand = Request.Form.Get(string.Format("parcel-{0}-content-{1}-type", j, k)).Trim();
                    pi.Description = Request.Form.Get(string.Format("parcel-{0}-content-{1}-type", j, k)).Trim();

                    if (order.Service.Name.Contains("顺丰奶粉包税"))
                    {
                        pi.TariffCode = repo.Context.yp_ems_goods.FirstOrDefault(y => y.name == pi.Description).id.ToString();
                    }
                    pi.Count = int.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-quantity", j, k)));
                    decimal unitPrice = decimal.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-cost", j, k)));
                    pi.UnitPrice = unitPrice;
                    pi.Value = Math.Round(unitPrice * (decimal)pi.Count, 2);
                    p.PackageItems.Add(pi);
                }
                if (order.Service.Name.Contains("奶粉包税6罐"))
                {
                    int count = p.PackageItems.Sum(item => item.Count).Value;
                    if (count != 6)
                    {
                        msg.Append(string.Format("包裹{0}的奶粉数量不等于6罐。", j + 1));
                    }
                }
                if (order.Service.Name.Contains("奶粉包税4罐"))
                {
                    int count = p.PackageItems.Sum(item => item.Count).Value;
                    if (count != 4)
                    {
                        msg.Append(string.Format("包裹{0}的奶粉数量不等于4罐。", j + 1));
                    }
                }
                if (order.Service.Name.Contains("奶粉包税"))
                {
                    if (p.PackageItems.Select(i => i.Description).Distinct().Count() != p.PackageItems.Count)
                    {
                        msg.Append(string.Format("包裹{0}的奶粉有重复货号。", j + 1));
                    }
                }
            }
        }

        #region old
        /*
        if (recipientCount >= order.Recipients.Count)
        {
            for (int i = 0; i < order.Recipients.Count; i++)
            {

            }
            for (int i = order.Recipients.Count; i < recipientCount; i++)
            {

            }

            for (int i = 0; i < recipientCount; i++)
            {
                Recipient recipient;
                if (i < order.Recipients.Count)
                {
                    recipient = order.Recipients.ElementAt(i);
                }
                else
                {
                    recipient = new Recipient();
                    order.Recipients.Add(recipient);
                }
                recipient.Name = Request.Form.Get(string.Format("addr-{0}-cn_name", i)).Trim();

                recipient.Province = Request.Form.Get(string.Format("addr-{0}-cn_province", i)).Trim();
                if (recipient.Province == "北京市" || recipient.Province == "天津市" || recipient.Province == "上海市" || recipient.Province == "重庆市")
                {
                    recipient.City = Request.Form.Get(string.Format("addr-{0}-cn_district", i)).Trim();
                    recipient.District = " ";
                }
                else
                {
                    recipient.City = Request.Form.Get(string.Format("addr-{0}-cn_city", i)).Trim();
                    recipient.District = Request.Form.Get(string.Format("addr-{0}-cn_district", i)).Trim();
                    if (string.IsNullOrEmpty(recipient.District))
                    {
                        recipient.District = " ";
                    }
                }

                recipient.Address = Request.Form.Get(string.Format("addr-{0}-cn_street", i)).Trim();
                recipient.PhoneNumber = Request.Form.Get(string.Format("addr-{0}-phone", i)).Trim();
                recipient.ZipCode = Request.Form.Get(string.Format("addr-{0}-postcode", i)).Trim();
                recipient.PyName = Request.Form.Get(string.Format("hd_name{0}", i)).Trim();
                recipient.PyCity = Request.Form.Get(string.Format("hd_city{0}", i)).Trim();
                recipient.PyAddress = Request.Form.Get(string.Format("hd_street{0}", i)).Trim();
                recipient.IDNumber = Request.Form.Get(string.Format("addr-{0}-idnumber", i)).Trim();

                if (order.Service.Name.Contains("奶粉包税") || order.Service.Name.Contains("杂物包税"))
                {
                    if (CheckIDNumber(recipient.Name, recipient.IDNumber) == "验证失败")
                    {
                        msg.Append(string.Format("收件人{0}的名字和身份证号不匹配。", recipient.Name));
                    }
                }
            }
        }

        List<Recipient> recipientList = order.Recipients.ToList();
        for (int i = 0; i < recipientList.Count; i++)
        {
            Recipient recipient = recipientList[i];
            recipient.Name = Request.Form.Get(string.Format("addr-{0}-cn_name", i)).Trim();

            recipient.Province = Request.Form.Get(string.Format("addr-{0}-cn_province", i)).Trim();
            if (recipient.Province == "北京市" || recipient.Province == "天津市" || recipient.Province == "上海市" || recipient.Province == "重庆市")
            {
                recipient.City = Request.Form.Get(string.Format("addr-{0}-cn_district", i)).Trim();
                recipient.District = " ";
            }
            else
            {
                recipient.City = Request.Form.Get(string.Format("addr-{0}-cn_city", i)).Trim();
                recipient.District = Request.Form.Get(string.Format("addr-{0}-cn_district", i)).Trim();
                if (string.IsNullOrEmpty(recipient.District))
                {
                    recipient.District = " ";
                }
            }

            recipient.Address = Request.Form.Get(string.Format("addr-{0}-cn_street", i)).Trim();
            recipient.PhoneNumber = Request.Form.Get(string.Format("addr-{0}-phone", i)).Trim();
            recipient.ZipCode = Request.Form.Get(string.Format("addr-{0}-postcode", i)).Trim();
            recipient.PyName = Request.Form.Get(string.Format("hd_name{0}", i)).Trim();
            recipient.PyCity = Request.Form.Get(string.Format("hd_city{0}", i)).Trim();
            recipient.PyAddress = Request.Form.Get(string.Format("hd_street{0}", i)).Trim();
            recipient.IDNumber = Request.Form.Get(string.Format("addr-{0}-idnumber", i)).Trim();    
          
            if (order.Service.Name.Contains("奶粉包税") || order.Service.Name.Contains("杂物包税"))
            {
                if (CheckIDNumber(recipient.Name, recipient.IDNumber) == "验证失败")
                {
                    msg.Append(string.Format("收件人{0}的名字和身份证号不匹配。", recipient.Name));
                }
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
            if (packages[i].PackageItems.Count <= itemsCount)
            {
                for (int j = 0; j < packages[i].PackageItems.Count; j++)
                {
                    PackageItem pi = packages[i].PackageItems.ElementAt(j);
                    pi.Description = Request.Form.Get(string.Format("parcel-{0}-content-{1}-type", i, j)).Trim();
                    pi.Count = int.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-quantity", i, j)));
                    decimal unitPrice = decimal.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-cost", i, j)));
                    pi.UnitPrice = unitPrice;
                    pi.Value = Math.Round(unitPrice * (decimal)pi.Count, 2);                   
                }
                for (int j = packages[i].PackageItems.Count; j < itemsCount; j++)
                {
                    PackageItem item = new PackageItem();
                    item.Description = Request.Form.Get(string.Format("parcel-{0}-content-{1}-type", i, j)).Trim();                  
                    item.Count = int.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-quantity", i, j)));
                    decimal unitPrice = decimal.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-cost", i, j)));
                    item.UnitPrice = unitPrice;
                    item.Value = Math.Round(unitPrice * (decimal)item.Count, 2);                    
                    packages[i].PackageItems.Add(item);
                }
            }
            else
            {
                for (int j = 0; j < itemsCount; j++)
                {
                    PackageItem pi = packages[i].PackageItems.ElementAt(j);
                    pi.Description = Request.Form.Get(string.Format("parcel-{0}-content-{1}-type", i, j)).Trim();
                    pi.Count = int.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-quantity", i, j)));
                    decimal unitPrice = decimal.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-cost", i, j)));
                    pi.UnitPrice = unitPrice;
                    pi.Value = Math.Round(unitPrice * (decimal)pi.Count, 2);
                }
                List<PackageItem> toRemove = new List<PackageItem>();
                for (int j = itemsCount; j < packages[i].PackageItems.Count; j++)
                {
                    PackageItem pi = packages[i].PackageItems.ElementAt(j);
                    toRemove.Add(pi);
                }
                repo.Context.PackageItems.RemoveRange(toRemove);
            }
            
            decimal weight = packages[i].Weight / itemsCount;
            packages[i].PackageItems.Clear();
            for (int j = 0; j < itemsCount; j++)
            {
                PackageItem item = new PackageItem();
                item.Description = Request.Form.Get(string.Format("parcel-{0}-content-{1}-type", i, j)).Trim();
                //item.Brand = Request.Form.Get(string.Format("parcel-{0}-content-{1}-brand", i, j)).Trim();
                //item.Spec = Request.Form.Get(string.Format("parcel-{0}-content-{1}-spec", i, j)).Trim();
                //item.SpecUnit = Request.Form.Get(string.Format("parcel-{0}-content-{1}-specUnit", i, j)).Trim();
                //item.TariffCode = "999999";
                item.Count = int.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-quantity", i, j)));                
                decimal unitPrice = decimal.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-cost", i, j)));
                item.UnitPrice = unitPrice;
                item.Value = Math.Round(unitPrice * (decimal)item.Count, 2);
                item.NettoWeight = Math.Round(weight, 3);                
                packages[i].PackageItems.Add(item);
            }
            packages[i].Value = packages[i].PackageItems.Sum(pi => pi.Value);
            if (order.Service.Name.Contains("自营奶粉包税6罐"))
            {
                int count = packages[i].PackageItems.Sum(item => item.Count).Value;
                if (count > 6)
                {
                    msg.Append(string.Format("包裹{0}的奶粉数量超过6罐。", i + 1));
                }
            }
            if (order.Service.Name.Contains("自营奶粉包税4罐"))
            {
                int count = packages[i].PackageItems.Sum(item => item.Count).Value;
                if (count > 4)
                {
                    msg.Append(string.Format("包裹{0}的奶粉数量超过4罐。", i + 1));
                }
            }
        }
        */
        #endregion
        //if (!order.Service.Name.Contains("自送"))
        {
            DateTime date;
            if (DateTime.TryParse(Request["pickup_time_0"], out date))
            {
                order.PickupTime = date;
                if (_999parcel.Visible)
                {
                    if (_999parcel.Value == "am")
                    {
                        order.PickupTime = order.PickupTime.Value.AddHours(9);
                    }
                    else
                    {
                        order.PickupTime = order.PickupTime.Value.AddHours(13);
                    }
                }
            }
            else
            {
                msg.Append("请输入取件时间。");
            }
        }       

        if (string.IsNullOrEmpty(order.SenderName))
        {
            msg.Append("请输入发件人的姓名。");
        }
        else if (string.IsNullOrEmpty(order.SenderCity))
        {
            msg.Append("请输入发件人的城市。");
        }
        else if (string.IsNullOrEmpty(order.SenderAddress1))
        {
            msg.Append("请输入发件人的地址。");
        }
        else if (string.IsNullOrEmpty(order.SenderZipCode))
        {
            msg.Append("请输入发件人的邮编。");
        }
        else if (string.IsNullOrEmpty(order.SenderPhone))
        {
            msg.Append("请输入发件人的电话。");
        }

        for (int i = 0; i < order.Recipients.Count; i++)
        {
            Recipient r = order.Recipients.ElementAt(i);
            if (string.IsNullOrEmpty(r.Name))
            {
                msg.Append(string.Format("请输入收件人{0}的姓名。", i + 1));
            }
            else if (string.IsNullOrEmpty(r.City))
            {
                msg.Append(string.Format("请输入收件人{0}的城市。", i + 1));
            }
            else if (string.IsNullOrEmpty(r.Address))
            {
                msg.Append(string.Format("请输入收件人{0}的地址。", i + 1));
            }
            else if (string.IsNullOrEmpty(r.ZipCode))
            {
                msg.Append(string.Format("请输入收件人{0}的邮编。", i + 1));
            }
            else if (string.IsNullOrEmpty(r.PhoneNumber))
            {
                msg.Append(string.Format("请输入收件人{0}的电话。", i + 1));
            }
        }
        if (msg.Length == 0)
        {
            return "pass";
        }
        else
        {
            return msg.ToString();
        }
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
        if (sb.Length > 0)
        {
            sb.Remove(sb.Length - 1, 1);
        }
        return sb.ToString();
    }

    [WebMethod]
    public static IEnumerable<string> GetItems()
    {
        UK_ExpressEntities repo = new UK_ExpressEntities();
        //var t = repo.Rank3Types.Select(r => r.Name).ToList();
        return repo.Rank3Types.Select(r => r.Name);
    }

    [WebMethod]
    public static IEnumerable<string> GetMilkPowderItems()
    {
        UK_ExpressEntities repo = new UK_ExpressEntities();
        return repo.MilkPowderSKUs.Select(m => m.Description);
    }

    [WebMethod]
    public static IEnumerable<string> GetTTKDMilkPowders(string name)
    {
        UK_ExpressEntities repo = new UK_ExpressEntities();
        if (name.Contains("自营奶粉包税6罐"))
        {
            return repo.TTKDMilkPowders.Where(t =>
                t.Name != "英国雀巢Nestle全脂Nido奶粉400g" &&
                t.Name != "英国Marvel脱脂奶粉340g" &&
                t.Name != "英国雅培小安素400g" &&
                t.Name != "英国雀巢Nestle全脂Nido奶粉400g" &&
                t.Name != "英国Marvel脱脂奶粉340g" &&
                t.Name != "英国Marvel脱脂奶粉278g" &&
                t.Name != "英国Marvel脱脂奶粉198g" &&
                t.Name != "英国tesco脱脂奶粉340g" &&
                t.Name != "英国tesco脱脂奶粉198g"
                ).Select(t => t.Name);
        }
        else
        {
            return repo.TTKDMilkPowders.Where(t =>
                !t.Name.Contains("羊奶粉")
                ).Select(t => t.Name);
        }
    }

    [WebMethod]
    public static IEnumerable<TTKDMilkPowder> GetTTKDMilkPowdersV2(string service)
    {
        string address = ConfigurationManager.AppSettings["TTKDDomainName"] + "/product-list";
        string key = ConfigurationManager.AppSettings["TTKDUserKey"];
        string serviceCode;
        if (service.Contains("自营奶粉包税4罐"))
        {
            serviceCode = "M4E";
        }
        else
        {
            serviceCode = "M6P";
        }
        string json = string.Format("{{\"userAccount\": \"{0}\", \"serviceCode\": \"{1}\"}}", key, serviceCode);
        string response = HttpHelper.HttpPost(address, json, ConfigurationManager.AppSettings["Authorization"]);
        var res = JsonConvert.DeserializeAnonymousType(response, new { Msg = string.Empty, ErrNo = 0, Data = new List<TTKDMilkPowder>() });
        return res.Data;   
    }

    public class TTKDMilkPowder
    {
        public string ProductID { get; set; }
        public string ProductName { get; set; }
        public int MaxQty { get; set; }
    }

    [WebMethod]
    public static IEnumerable<object> GetSFMilkPowders(string name)
    {
        UK_ExpressEntities repo = new UK_ExpressEntities();
        return from y in repo.yp_ems_goods select y.name;
    }

    [WebMethod]
    public static string GetOrderPrice(int sid, int index, decimal weight, decimal length, decimal width, decimal height)
    {
        UK_ExpressEntities repo = new UK_ExpressEntities();
        Service s = repo.Services.Find(sid);
        ServiceView sv = new ServiceView(s);
        decimal maxWeight = s.PriceList.PriceItems.Max(i => i.Weight);
        if (weight > maxWeight)
        {
            weight = maxWeight;
        }
        Package p = new Package() { Weight = weight, Length = length, Width = width, Height = height };
        decimal cost = sv.GetPackageDeliverPrice(p);
        return cost.ToString();
    }

    [WebMethod]
    public static void SetDefaultSender(string username, string senderName, string city, string zipcode, string address1, string address2, string address3, string phone, string mail)
    {
        UK_ExpressEntities repo = new UK_ExpressEntities();
        aspnet_User user = repo.aspnet_User.FirstOrDefault(u => u.UserName == username);
        DefaultSender sender;
        if (user.DefaultSender == null)
        {
            sender = new DefaultSender();            
            user.DefaultSender = sender;
        }
        else
        {
            sender = user.DefaultSender;
        }
        sender.Address1 = address1;
        sender.Address2 = address2;
        sender.Address3 = address3;
        sender.City = city;
        sender.Mail = mail;
        sender.Name = senderName;
        sender.Phone = phone;
        sender.ZipCode = zipcode;
        repo.SaveChanges();
    }

    public int GetMaxItemCount()
    {
        if (Order.Service.Name.Contains("奶粉包税4罐"))
        {
            return 4;
        }
        else if (Order.Service.Name.Contains("奶粉包税6罐"))
        {
            return 6;
        }
        else
        {
            return 999999;
        }
    }

    public string CheckIDNumber(string name, string number)
    {
        UK_ExpressEntities ef = new UK_ExpressEntities();
        IDNumber idNumber = ef.IDNumbers.FirstOrDefault(i => i.Number == number);
        if (idNumber == null)
        {
            string url = string.Format("http://op.juhe.cn/idcard/query?key=0f2dc8c56cbce8c6e0c9364191bb6f32&idcard={0}&realname={1}", number, name);
            string response = HttpHelper.HttpGet(url);           
            //string response = "{\"reason\":\"成功\",\"result\":{\"realname\":\"兰琳婕\",\"idcard\":\"510108198412072127\",\"res\":1},\"error_code\":0}";
            var r= JsonConvert.DeserializeAnonymousType(response, new { Reason = string.Empty, Result = new { RealName = string.Empty, IDCard = string.Empty, Res = string.Empty }, ErrorCode = string.Empty });
           
            if (r.Result != null && r.Result.Res == "1")
            {
                IDNumber idNumberNew = new IDNumber() { Name = name, Number = number };
                repo.Context.IDNumbers.Add(idNumberNew);
                repo.Context.SaveChanges();
                return "验证成功";
            }
            else
            {
                return "验证失败";
            }
        }
        else
        {
            if (name == idNumber.Name)
            {
                return "验证成功";
            }
            else
            {
                return "验证失败";
            }
        }
    }

    public string GetBrandAndSpecVibility()
    {
        return ServiceView.Name.Contains("杂物包税") ? "style=visibility:hidden;" : "style=visibility:hidden;";
    }

    public IEnumerable<Recipient> GetRecipentBook()
    {
        string user = Membership.GetUser().UserName;
        var book = repo.Context.Recipients.Where(r => r.Order.User == user).ToList().Distinct<Recipient>(new RecipientCompare());
        return book;
    }

    public class RecipientCompare : IEqualityComparer<Recipient>
    {
        public bool Equals(Recipient x, Recipient y)
        {
            return (x.Name == y.Name && x.Province == y.Province && x.City == y.City && x.District == y.District && x.Address == y.Address && x.ZipCode == y.ZipCode);
        }

        public int GetHashCode(Recipient obj)
        {
            // return obj.GetHashCode();  
            return obj.ToString().ToLower().GetHashCode();
        }
    } 
    
    public string GetHtml(Package p, string kind)
    {
        if (p == null)
        {
            return string.Empty;
        }
        else
        {
            decimal v;
            switch (kind)
            {
                case "weight":
                    v = p.Weight;
                    break;
                case "length":
                    v = p.Length;
                    break;
                case "width":
                    v = p.Width;
                    break;
                case "height":
                    v = p.Height;
                    break;
                default:
                    return string.Empty;
            }
            if (order.SuccessPaid == false)
            {
                return string.Format("<span class=\"input-small\" id=\"id_parcel-0-{0}\" name=\"parcel-0-{0}\" style=\"width: 55px\"><strong>{1}</strong></span>", kind, v);
            }
            if (order.Service.Name.Contains("Parcelforce"))
            {
                int maxWeight;
                if (order.Service.Name.Contains("Parcelforce Priority 小包裹"))
                {
                    maxWeight = 2;
                }
                else if (order.Service.Name.Contains("Parcelforce Child Car Seat 儿童安全座椅专线"))
                {
                    maxWeight = 13;
                }
                else
                {
                    maxWeight = 30;
                }
                return string.Format("<input class=\"input-small\" id=\"id_parcel-0-{0}\" name=\"parcel-0-{0}\" style=\"width: 45px\" value=\"{1}\" type=\"number\" step=\"0.1\" max=\"{2}\" min=\"{3}\"></input>", kind, v, kind == "weight" ? maxWeight : 105, kind == "weight" ? 0.1 : 1.0);
            }
            else
            {
                return string.Format("<span class=\"input-small\" id=\"id_parcel-0-{0}\" name=\"parcel-0-{0}\" style=\"width: 55px\"><strong>{1}</strong></span>", kind, v);
            }
        }
    }   
}