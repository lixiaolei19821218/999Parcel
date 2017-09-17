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
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

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

        //Service service = repo.Services.FirstOrDefault(s => s.Id == order.ServiceID);
        sv = new ServiceView(order.Service);
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
            }/*
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
                old.SenderEmail = order.SenderEmail;
                foreach (Recipient r in order.Recipients)
                {
                    old.Recipients.Add(r);
                }
                old.Cost = sv.GetSendPrice(old);
            }*/

            
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
            if (sv.Name.Contains("Parcelforce") || sv.Name.Contains("自营奶粉包税"))
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
        StringBuilder msg = new StringBuilder();
        order.SenderName = Request.Form.Get("billing_detail_name").Trim();
        order.SenderCity = Request.Form.Get("billing_detail_city").Trim();
        order.SenderPhone = Request.Form.Get("billing_detail_phone").Trim();
        if (order.SenderPhone.Length != 11)
        {
            msg.Append("请输入11位电话号码。");
        }
        order.SenderAddress1 = Request.Form.Get("billing_detail_street").Trim();
        order.SenderAddress2 = Request.Form.Get("billing_detail_street2").Trim();
        order.SenderAddress3 = Request.Form.Get("billing_detail_street3").Trim();
        order.SenderZipCode = Request.Form.Get("billing_detail_postcode").Trim();
        order.SenderEmail = Request.Form.Get("id_billing_detail_email").Trim();

        
        if (order.Id != 0)
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
        }
        order.Recipients.Clear();
        
        int recipientCount = int.Parse(Request.Form.Get("addr-TOTAL_FORMS"));
        for (int i = 0; i < recipientCount; i++)
        {
            Recipient recipient = new Recipient();
            order.Recipients.Add(recipient);
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
            //recipient.PyName = Request.Form.Get(string.Format("hd_name{0}", i)).Trim();
            //recipient.PyCity = Request.Form.Get(string.Format("hd_city{0}", i)).Trim();
            //recipient.PyAddress = Request.Form.Get(string.Format("hd_street{0}", i)).Trim();
            recipient.IDNumber = Request.Form.Get(string.Format("addr-{0}-idnumber", i)).Trim();

            if (order.Service.Name.Contains("奶粉包税") || order.Service.Name.Contains("杂物包税"))
            {
                if (CheckIDNumber(recipient.Name, recipient.IDNumber) == "验证失败")
                {
                    msg.Append(string.Format("收件人{0}的名字和身份证号不匹配。", recipient.Name));
                }
            }

           
        }

        int parcelCount = int.Parse(Request.Form.Get("parcel-TOTAL_FORMS"));
        int weight = order.Service.Name.Contains("自营奶粉包税6罐") ? 7 : 5;
        for (int j = 0; j < parcelCount; j++)
        {
            int recipientNum = int.Parse(Request.Form.Get(string.Format("parcel-{0}-address_id", j)));
            Package p = new Package() { Weight = weight, Length = 1, Width = 1, Height = 1 };
            order.Recipients.ElementAt(recipientNum).Packages.Add(p);
            int itemsCount = int.Parse(Request.Form.Get(string.Format("parcel-{0}-content-TOTAL_FORMS", j)));
            for (int k = 0; k < itemsCount; k++)
            {
                PackageItem pi = new PackageItem();
                pi.Description = Request.Form.Get(string.Format("parcel-{0}-content-{1}-type", j, k)).Trim();
                pi.Count = int.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-quantity", j, k)));
                decimal unitPrice = decimal.Parse(Request.Form.Get(string.Format("parcel-{0}-content-{1}-cost", j, k)));
                pi.UnitPrice = unitPrice;
                pi.Value = Math.Round(unitPrice * (decimal)pi.Count, 2);
                p.PackageItems.Add(pi);
            }
            if (order.Service.Name.Contains("自营奶粉包税6罐"))
            {
                int count = p.PackageItems.Sum(item => item.Count).Value;
                if (count > 6)
                {
                    msg.Append(string.Format("包裹{0}的奶粉数量超过6罐。", j + 1));
                }
            }
            if (order.Service.Name.Contains("自营奶粉包税4罐"))
            {
                int count = p.PackageItems.Sum(item => item.Count).Value;
                if (count > 4)
                {
                    msg.Append(string.Format("包裹{0}的奶粉数量超过4罐。", j + 1));
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
                t.Name != "英国雅培小安素400g"
                ).Select(t => t.Name);
        }
        else
        {
            return repo.TTKDMilkPowders.Where(t =>
                !t.Name.Contains("羊奶粉")
                ).Select(t => t.Name);
        }
    }

    public int GetMaxItemCount()
    {
        if (Order.Service.Name.Contains("自营奶粉包税4罐"))
        {
            return 4;
        }
        else if (Order.Service.Name.Contains("自营奶粉包税6罐"))
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
        IDNumber idNumber = repo.Context.IDNumbers.FirstOrDefault(i => i.Number == number);
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
    protected void Button1_Click(object sender, EventArgs e)
    {
        //UpdatePanel1.r
    }
}