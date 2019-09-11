using Newtonsoft.Json;
using NPinyin;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Security;

public enum TTKDType { FourTin, SixTin }
/// <summary>
/// Summary description for SendHelper
/// </summary>
public static class SendHelper
{
    private const string tt6Tin = "001";
    private const string tt4Tin = "003";

    public static void SendToTTKD(Order order, TTKDType type)
    {
        foreach (Recipient r in order.Recipients)
        {
            if ( r.SuccessPaid == null || (r.SuccessPaid == false && r.Errors.StartsWith("FAIL")) )
            {
                StringBuilder data = new StringBuilder();
                string code = type == TTKDType.SixTin ? tt6Tin : tt4Tin;
                data.Append(string.Format("{{\"serviceCode\":\"{0}\",\"userKey\":\"{1}\",\"packageList\": [ ", code, ConfigurationManager.AppSettings["TTKDUserKey"]));
                foreach (Package p in r.Packages)
                {
                    data.Append("{");
                    data.Append(string.Format("\"sendName\": \"{0}\",", order.SenderName));
                    data.Append(string.Format("\"sendPhone\": \"{0}\",", order.SenderPhone));
                    data.Append("\"sendCompany\": \"999 Parcel\",");
                    data.Append(string.Format("\"sendAddressLine1\": \"{0}\",", order.SenderAddress1));
                    data.Append(string.Format("\"sendAddressLine2\": \"{0}\",", order.SenderAddress2));
                    data.Append(string.Format("\"sendAddressLine3\": \"{0}\",", order.SenderAddress3));
                    data.Append(string.Format("\"sendCity\": \"{0}\",", order.SenderCity));
                    data.Append(string.Format("\"sendZipCode\": \"{0}\",", order.SenderZipCode));
                    data.Append("\"sendCountry\": \"UK\",");
                    data.Append("\"remarks\": \"\", ");
                    data.Append(string.Format("\"receiverID\": \"{0}\",", r.IDNumber));
                    data.Append(string.Format("\"receiverName\": \"{0}\",", r.Name));
                    data.Append(string.Format("\"receiverPhone\": \"{0}\",", r.PhoneNumber));
                    data.Append(string.Format("\"receiverZipCode\": \"{0}\",", r.ZipCode));
                    data.Append(string.Format("\"receiverProvinces\": \"{0}\",", r.Province));
                    data.Append(string.Format("\"receiverCity\": \"{0}\",", r.City));
                    data.Append(string.Format("\"receiverArea\": \"{0}\",", r.District));
                    data.Append(string.Format("\"receiverAddr\": \"{0}\",", r.Address));
                    int weight = type == TTKDType.SixTin ? 7 : 5;
                    data.Append(string.Format("\"totalWeight\": {0},", weight));
                    data.Append("\"productInfo\": [");
                    foreach (PackageItem i in p.PackageItems)
                    {
                        data.Append("{");
                        data.Append(string.Format("\"productName\": \"{0}\",", i.Description));
                        data.Append(string.Format("\"total\": {0}", i.Count));
                        data.Append("},");
                    }
                    data.Remove(data.Length - 1, 1);
                    data.Append("]},");
                }
                data.Remove(data.Length - 1, 1);
                data.Append("]}");

                r.Json = data.ToString();

                string response;
                try
                {
                    response = HttpHelper.HttpPost(string.Format("{0}/interface/make-order", ConfigurationManager.AppSettings["TTKDDomainName"]), r.Json, ConfigurationManager.AppSettings["Authorization"]);
                }
                catch (Exception ex)
                {
                    r.SuccessPaid = false;
                    r.Errors = "Exception: " + ex.Message;
                    foreach (Package p in r.Packages)
                    {
                        p.Status = "Exception";
                        p.Response = "Exception message: " + ex.Message;                       
                    }
                    continue;
                }
                
                var res = JsonConvert.DeserializeAnonymousType(response, new { Msg = string.Empty, Data = new { OrderNum = string.Empty, Mail_Nums = new List<string>() } });               

                if (res.Msg == "success")
                {
                    r.SuccessPaid = true;
                    string path = GetTTKDLabel(res.Data.OrderNum, type);

                    r.WMLeaderPdf = path;
                    for (int i = 0; i < r.Packages.Count; i++)
                    {
                        Package p = r.Packages.ElementAt(i);
                        p.Status = "SUCCESS";
                        p.TrackNumber = res.Data.Mail_Nums[i];
                        p.Pdf = path;
                    }

                    string mailBody = HttpContext.Current.Application["MailBody"].ToString().Replace("999ParcelOrderNumber", string.Format("{0:d9}", r.Order.Id));
                    EmailService.SendEmailAync(string.IsNullOrEmpty(r.Order.SenderEmail) ? Membership.GetUser().Email : r.Order.SenderEmail, "您在999Parcel的订单" + string.Format("{0:d9}", r.Order.Id), mailBody, new string[] { System.AppDomain.CurrentDomain.BaseDirectory + path });
                }
                else
                {
                    r.SuccessPaid = false;
                    r.Errors = "FAIL. TTKD: " + res.Msg;
                    foreach (Package p in r.Packages)
                    {
                        p.Status = "FAIL";
                        p.Response = "TTKD: " + res.Msg;                        
                    }
                }
            }
        }
        order.SuccessPaid = order.Recipients.All(r => r.SuccessPaid ?? false);
    }

    public static void SendToTTKD_V2(Order order, TTKDType type)
    {       
        for (int n = 0; n < order.Recipients.Count; n++)
        {
            Recipient r = order.Recipients.ElementAt(n);
            dynamic o = new System.Dynamic.ExpandoObject();
            o.userAccount = ConfigurationManager.AppSettings["TTKDUserKey"];
            o.requestId = "O" + order.Id + "R" + r.Id + "N" + n;
            List<System.Dynamic.ExpandoObject> dpList = new List<System.Dynamic.ExpandoObject>();
            foreach (Package p in r.Packages)
            {
                dynamic dp = new System.Dynamic.ExpandoObject();
                dp.packageId = p.Id;
                dp.serviceCode = order.Service.Name.Contains("自营奶粉包税4罐") ? "M4E": "M6P";
                dp.remarks = "999Parcel";
                dp.senderName = order.SenderName;
                dp.senderPhone = order.SenderPhone;
                dp.senderCompany = "999Parcel";
                dp.senderAddrLine1 = order.SenderAddress1;
                dp.senderAddrLine2 = order.SenderAddress2;
                dp.senderAddrLine3 = order.SenderAddress3;
                dp.senderCity = order.SenderCity;
                dp.senderZipCode = order.SenderZipCode;
                dp.senderCountry = "GB";
                dp.receiverID = r.IDNumber;
                dp.receiverName = r.Name;
                dp.receiverPhone = r.PhoneNumber;
                dp.receiverZipCode = r.ZipCode;
                dp.receiverProvince = r.Province;
                dp.receiverCity = r.City;
                dp.receiverArea = r.District;
                dp.receiverAddr = r.Address;
                dp.totalWeight = "";
                dp.length = "";
                dp.width = "";
                dp.height = "";
                dp.insurance = "";

                List<System.Dynamic.ExpandoObject> diList = new List<System.Dynamic.ExpandoObject>();
                foreach (PackageItem pi in p.PackageItems)
                {
                    dynamic di = new System.Dynamic.ExpandoObject();
                    di.productId = pi.Description;
                    di.productQty = pi.Count;
                    diList.Add(di);                    
                }
                dp.productInfo = diList;

                dpList.Add(dp);
            }

            o.packageList = dpList;
            string json = JsonConvert.SerializeObject(o);
            r.Json = json;

            string response;
            try
            {
                response = HttpHelper.HttpPost(string.Format("{0}/make-order", ConfigurationManager.AppSettings["TTKDDomainName"]), json, ConfigurationManager.AppSettings["Authorization"]);
            }
            catch (Exception ex)
            {
                r.SuccessPaid = false;
                r.Errors = "Exception: " + ex.Message;
                foreach (Package p in r.Packages)
                {
                    p.Status = "Exception";
                    p.Response = "Exception message: " + ex.Message;
                }
                continue;
            }

            var res = JsonConvert.DeserializeAnonymousType(response, new { msg = string.Empty, errno = string.Empty, requestId = string.Empty, data = new { orderNum = string.Empty, totalPackage = 0, packageList = new List<object>() } });
            if (res.msg == "success")
            {
                r.SuccessPaid = true;
                r.WMLeaderNumber = res.data.orderNum;
                //r.WMLeaderPdf = GetTTKDLabelV2(res.data.orderNum);
                List<string> labels = new List<string>();
                for (int i = 0; i < r.Packages.Count; i++)
                {
                    Package p = r.Packages.ElementAt(i);
                    p.TrackNumber = JsonConvert.DeserializeAnonymousType(res.data.packageList[i].ToString(), new { packageId = string.Empty, mailNum = string.Empty }).mailNum;
                    p.Pdf = GetTTKDLabelV2(p.TrackNumber);
                    labels.Add(p.Pdf);
                    p.Status = "SUCCESS";
                }
                string mailBody = HttpContext.Current.Application["MailBody"].ToString().Replace("999ParcelOrderNumber", string.Format("{0:d9}", r.Order.Id));
                EmailService.SendEmailAync(string.IsNullOrEmpty(r.Order.SenderEmail) ? Membership.GetUser().Email : r.Order.SenderEmail, "您在999Parcel的订单" + string.Format("{0:d9}", r.Order.Id), mailBody, labels.Select(l => System.AppDomain.CurrentDomain.BaseDirectory + l).ToArray());
            }
            else
            {
                r.SuccessPaid = false;
                r.Errors = "FAIL. TTKD: " + res.msg;
                foreach (Package p in r.Packages)
                {
                    p.Status = "FAIL";
                    p.Response = "FAIL. TTKD: " + res.msg;
                }
            }
        }
        order.SuccessPaid = order.Recipients.All(r => r.SuccessPaid ?? false);
    }

    public static string GetTTKDLabel(string orderNum, TTKDType type)
    {
        string path = string.Empty;
        StringBuilder json = new StringBuilder("{");
        string code = type == TTKDType.SixTin ? tt6Tin : tt4Tin;
        json.Append(string.Format("\"serviceCode\": \"{0}\",", code));
        json.Append(string.Format("\"userKey\": \"{0}\",", ConfigurationManager.AppSettings["TTKDUserKey"]));
        json.Append(string.Format("\"orderNum\": \"{0}\"}}", orderNum));
        string response;
        try
        {
            response = HttpHelper.HttpPost(string.Format("{0}/interface/order-label", ConfigurationManager.AppSettings["TTKDDomainName"]), json.ToString(), ConfigurationManager.AppSettings["Authorization"]);
        }
        catch (Exception ex)
        {
            return "Get label error, message: " + ex.Message;
        }
        var res = JsonConvert.DeserializeAnonymousType(response, new { ErrNo = string.Empty, Msg = string.Empty, Data = new { Label = string.Empty } });

        if (res.Msg == "success")
        {
            string folder = string.Format("{0}files\\TTKD\\{1}", HttpRuntime.AppDomainAppPath, Membership.GetUser().UserName);
            if (!Directory.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }
            string label = string.Format("{0}\\{1}.pdf", folder, orderNum);
            byte[] stream = Convert.FromBase64String(res.Data.Label);
            FileStream file = new FileStream(label, FileMode.OpenOrCreate, FileAccess.ReadWrite);
            file.Write(stream, 0, stream.Length);
            file.Close();
            path = string.Format("files\\TTKD\\{0}\\{1}.pdf", Membership.GetUser().UserName, orderNum);
        }
        return path;
    }

    public static string GetTTKDLabelV2(string orderNum)
    {
        string url = ConfigurationManager.AppSettings["TTKDDomainName"] + "/order-label";
        string json = string.Format("{{\"userAccount\": \"{0}\", \"mailNum\": \"{1}\"}}", ConfigurationManager.AppSettings["TTKDUserKey"], orderNum);
        string response = HttpHelper.HttpPost(url, json, ConfigurationManager.AppSettings["Authorization"]);
        var res = JsonConvert.DeserializeAnonymousType(response, new { msg = string.Empty, errno = string.Empty, data = new { label = new byte[] { } } });

        string path = string.Empty;
        if (res.msg == "success")
        {
            string folder = string.Format("{0}files\\TTKD\\{1}", HttpRuntime.AppDomainAppPath, Membership.GetUser().UserName);
            if (!Directory.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }
            string label = string.Format("{0}\\{1}.pdf", folder, orderNum);
            //byte[] stream = Convert.FromBase64String(res.data.label);
            byte[] stream = res.data.label;
            FileStream file = new FileStream(label, FileMode.OpenOrCreate, FileAccess.ReadWrite);
            file.Write(stream, 0, stream.Length);
            file.Close();
            path = string.Format("files\\TTKD\\{0}\\{1}.pdf", Membership.GetUser().UserName, orderNum);
        }
        return path;
    }

    public static void SendToPF(Order order)
    {
        int sid = 0;
        if (order.Service.Name.Contains("Parcelforce Economy"))
        {
            sid = 27;
        }
        else if (order.Service.Name.Contains("Parcelforce Priority"))
        {
            sid = 22;
        }
        else if (order.Service.Name.Contains("Parcelforce Luggage"))
        {
            sid = 21;
        }
        else if (order.Service.Name.Contains("顺丰奶粉包税4罐"))
        {
            sid = 34;
        }
        else if (order.Service.Name.Contains("顺丰奶粉包税6罐"))
        {
            sid = 36;
        }

        List<string> oFiles = new List<string>();
        foreach (Recipient r in order.Recipients)
        {
            foreach (Package p in r.Packages.Where(pacecl => string.IsNullOrEmpty(pacecl.Status) || pacecl.Status == "FAIL"))
            {
                string senderName = HasChinese(order.SenderName) ? Pinyin.GetPinyin(order.SenderName) : order.SenderName;
                string senderCity = HasChinese(order.SenderCity) ? Pinyin.GetPinyin(order.SenderCity) : order.SenderCity;
                string json;
                if (sid == 21)
                {
                    json = JsonConvert.SerializeObject(new
                    {
                        Pacel = new { weight = p.Weight, length = p.Length, height = p.Height, width = p.Width, item = p.PackageItems.Select(i => new { name = i.Description, number = i.Count, value = i.UnitPrice }) },
                        BillAddress = new { fullname_en = senderName, city_en = senderCity, zip = order.SenderZipCode, phone = order.SenderPhone, email = order.SenderEmail, address1_en = order.SenderAddress1, address2_en = order.SenderAddress2 + " " + order.SenderAddress3 },
                        ShipAddress = new { fullname_en = r.PyName, fullname = r.Name, city_en = r.PyProvince + ", " + r.PyCity + ", " + r.PyDistrict, city = r.Province + ", " + r.City + ", " + r.District, address1_en = r.PyAddress, address1 = r.Address, zip = r.ZipCode, phone = r.PhoneNumber, email = Membership.GetUser().Email },
                        serviceId = sid,
                        type = 1,
                        to = 1,
                        pickup = "1|" + order.PickupTime.Value.ToString("yyyy-MM-dd")
                    });
                }
                else if (sid == 22 || sid == 27)
                {
                    json = JsonConvert.SerializeObject(new
                    {
                        Pacel = new { weight = p.Weight, length = p.Length, height = p.Height, width = p.Width, item = p.PackageItems.Select(i => new { name = i.Description, number = i.Count, value = i.UnitPrice }) },
                        BillAddress = new { fullname_en = senderName, city_en = senderCity, zip = order.SenderZipCode, phone = order.SenderPhone, email = order.SenderEmail, address1_en = order.SenderAddress1, address2_en = order.SenderAddress2 + " " + order.SenderAddress3 },
                        ShipAddress = new { fullname_en = r.PyName, fullname = r.Name, city_en = r.PyProvince + ", " + r.PyCity + ", " + r.PyDistrict, city = r.Province + ", " + r.City + ", " + r.District, address1_en = r.PyAddress, address1 = r.Address, zip = r.ZipCode, phone = r.PhoneNumber, email = Membership.GetUser().Email },
                        serviceId = sid,
                        type = 1,
                        to = 1
                    });
                }
                else//34,36 顺丰奶粉包税
                {
                    json = JsonConvert.SerializeObject(new
                    {
                        Pacel = new { weight = p.Weight, length = p.Length, height = p.Height, width = p.Width, item = p.PackageItems.Select(i => new { name = i.Description, number = i.Count, value = i.UnitPrice, cate = i.TariffCode }) },
                        BillAddress = new { fullname_en = senderName, city_en = senderCity, zip = order.SenderZipCode, phone = order.SenderPhone, email = order.SenderEmail, address1_en = order.SenderAddress1, address2_en = order.SenderAddress2 + " " + order.SenderAddress3 },
                        ShipAddress = new { fullname_en = r.PyName, fullname = r.Name, city_en = r.PyProvince + ", " + r.PyCity + ", " + r.PyDistrict, city = r.Province + ", " + r.City + ", " + r.District, address1_en = r.PyAddress, address1 = r.Address, zip = r.ZipCode, phone = r.PhoneNumber, email = Membership.GetUser().Email, identity = r.IDNumber },
                        serviceId = sid,
                        type = 1,
                        to = 1
                    });
                }

                p.Json = json;
                string response;
                try
                {
                    response = HttpHelper.HttpPost("https://www.eto.uk.com/api/createShipment", json, "", ConfigurationManager.AppSettings["eto_apikey"]);
                }
                catch (Exception ex)
                {
                    p.Status = "Exception";
                    p.Response = "Exception message: " + ex.Message;
                    continue;
                }
                
                try
                {
                    var res = JsonConvert.DeserializeAnonymousType(response, new { ems = string.Empty, status = string.Empty, shipmentId = string.Empty, label = new List<string>() });
                    if (res.status == "success")
                    {
                        p.Status = "SUCCESS";
                        p.TrackNumber = res.ems;

                        List<string> files = new List<string>();
                        foreach (string pdf in res.label)
                        {
                            files.Add(HttpHelper.Download(pdf, Membership.GetUser().UserName));
                        }
                        oFiles.AddRange(files);
                        p.Pdf = HttpHelper.ZipFiles(files, Membership.GetUser().UserName, res.shipmentId);
                    }
                    else
                    {
                        p.Status = "FAIL";
                        p.Response = res.status;
                    }
                }
                catch (Exception ex)
                {
                    p.Status = "Exception";
                    p.Response = "Exception message: " + ex.Message + "Response: " + response;
                }
            }
            r.SuccessPaid = r.Packages.All(p => p.Status == "SUCCESS");
        }

        order.SuccessPaid = order.Recipients.All(r => r.SuccessPaid ?? false);
        if (order.SuccessPaid ?? false)
        {
            string mailBody = HttpContext.Current.Application["MailBody"].ToString().Replace("999ParcelOrderNumber", string.Format("{0:d9}", order.Id));
            EmailService.SendEmailAync(string.IsNullOrEmpty(order.SenderEmail) ? Membership.GetUser().Email : order.SenderEmail, "您在999Parcel的订单" + string.Format("{0:d9}", order.Id), mailBody, oFiles.ToArray());
        }
    }

    public static void SendOrder(Order order)
    {
        if (order.Service.Name.Contains("自营奶粉包税"))
        {
            TTKDType t;
            if (order.Service.Name.Contains("自营奶粉包税6罐"))
            {
                t = TTKDType.SixTin;
            }
            else
            {
                t = TTKDType.FourTin;
            }
            SendToTTKD_V2(order, t);
        }
        else if (order.Service.Name.Contains("Parcelforce") || order.Service.Name.Contains("顺丰奶粉包税"))
        {
            SendToPF(order);
        }
    }

    public static string DeleteChineseWord(string str)
    {
        string retValue = str;
        if (System.Text.RegularExpressions.Regex.IsMatch(str, @"[\u4e00-\u9fa5]"))
        {
            retValue = string.Empty;
            var strsStrings = str.ToCharArray();
            for (int index = 0; index < strsStrings.Length; index++)
            {
                if (strsStrings[index] >= 0x4e00 && strsStrings[index] <= 0x9fa5)
                {
                    continue;
                }
                retValue += strsStrings[index];
            }
        }
        return retValue;
    }

    public static bool HasChinese(this string str)
    {
        return Regex.IsMatch(str, @"[\u4e00-\u9fa5]");
    }

    public static void PayOrders(IEnumerable<Order> orders, bool freePickupCost, int total999PickupCount)
    {
        List<string> attachmentPaths = new List<string>();

        TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
        string timeStamp = Convert.ToInt64(ts.TotalSeconds).ToString();

        foreach (Order o in orders)
        {
            if (total999PickupCount >= 3)
            {
                o.PickupPrice = 0m;
            }
            switch (o.Service.Name.Trim())
            {
                case "荷兰邮政 - 免费取件":
                case "荷兰邮政 - UKMail 取件":

                    break;
                case "Parcelforce Economy - 诚信物流取件":
                    
                case "Parcelforce Priority 小包裹 - 诚信物流取件":
                   
                case "Parcelforce Economy - 自送仓库":
                    
                case "Parcelforce Priority 小包裹 - 自送仓库":
                   
                case "Parcelforce Luggage - 大行李专线":

                case "Parcelforce Child Car Seat 儿童安全座椅专线 - 诚信物流取件":

                case "Parcelforce Child Car Seat 儿童安全座椅专线 - 自送仓库":

                case "顺丰奶粉包税4罐 - 自送仓库":

                case "顺丰奶粉包税6罐 - 自送仓库":

                case "顺丰奶粉包税4罐 - 诚信物流取件":

                case "顺丰奶粉包税6罐 - 诚信物流取件":
                    SendToPF(o);
                    break;
                case "Bpost - 诚信物流取件":
                    //SendBpostLciFile(o);
                    //SendToBpost(o);
                    break;
                case "Bpost - UKMail 取件":
                    //if (UKMailCollection(o))
                    {
                      //  SendToBpost(o);
                    }
                    break;
                case "杂物包税专线（100镑以内） - 自送仓库":
                case "杂物包税专线（100镑以内） - 诚信物流取件":
                case "杂物包税专线（200镑以内） - 自送仓库":
                case "杂物包税专线（200镑以内） - 诚信物流取件":
                    //SendTo4PX(o);
                    break;
                case "奶粉包税专线 - 诚信物流取件":
                case "奶粉包税专线 - 自送仓库":
                    //SendToBpost(o, "LGINTSTD");
                    break;
                case "自营奶粉包税4罐 - 自送仓库":
                case "自营奶粉包税4罐 - 诚信物流取件":
                    SendToTTKD_V2(o, TTKDType.FourTin);
                    break;
                case "自营奶粉包税6罐 - 自送仓库":
                case "自营奶粉包税6罐 - 诚信物流取件":
                    SendToTTKD_V2(o, TTKDType.SixTin);
                    break;
                default:
                    break;
            }

            #region 华盟
            /*
                foreach (Recipient r in o.Recipients)
                {
                    OrderServiceClient client = new OrderServiceClient();
                    int parcelCount = r.Packages.Count;
                    string[] purposeOfShipment = new string[parcelCount];
                    for (int i = 0; i < purposeOfShipment.Length; i++)
                    {
                        purposeOfShipment[i] = "Gift";
                    }

                    OrderResponse response = client.OrderPlace(
                        r.Packages.Select(p => p.Detail).ToArray(),
                        purposeOfShipment,
                        r.Packages.Select(p => (float)p.Height).ToArray(),
                        r.Packages.Select(p => (float)p.Length).ToArray(),
                        r.Packages.Select(p => (float)p.Width).ToArray(),
                        r.Packages.Select(p => (float)p.Weight).ToArray(),
                        r.Packages.Select(p => (float)p.Value).ToArray(),
                        parcelCount,
                        wmPassword,
                        wmUsername,
                        r.ZipCode,
                        r.Address,
                        r.City,
                        "Personal",
                        r.Name,
                        "China",
                        r.PhoneNumber,
                        r.Order.SenderAddress1 + " " + r.Order.SenderAddress2 + " " + r.Order.SenderAddress3,
                        r.Order.SenderCity,
                        "Personal",
                        r.Order.SenderName,
                        "UK",
                        r.Order.SenderPhone,//"B29 7sn",
                        r.Order.SenderZipCode,
                        wmService,
                        r.Order.PickupTime.ToString()
                        );

                    if (response.Errors == null)
                    {
                        //国际追踪号
                        string tracknumber = response.TrackNumber;
                        //WM的订单号，主订单号
                        string wm_leadernumber = response.LeaderOrderNumber;
                        //WM的包裹号，用逗号分隔
                        string wm_ordernumber = response.OrderNumber;
                        //返回的pdf信息，
                        LabelResponse labelResponse_leader = client.GetLabelByWMLeaderNumber(wmUsername, wmPassword, wm_leadernumber);
                        //订单合并成的一个pdf，输入为主订单号
                        if (labelResponse_leader.Errors == null)
                        {
                            byte[] byt = labelResponse_leader.Label;
                            string folderPath = AppDomain.CurrentDomain.BaseDirectory + "pdf\\" + Membership.GetUser().UserName;
                            if (!Directory.Exists(folderPath))
                            {
                                Directory.CreateDirectory(folderPath);
                            }
                            string attachment = folderPath + "\\" + wm_leadernumber + ".pdf";
                            File.WriteAllBytes(attachment, byt);
                           
                            r.WMLeaderNumber = wm_leadernumber;
                            r.WMLeaderPdf = wm_leadernumber + ".pdf"; 
                            string[] tracknumbers = tracknumber.Split(',');
                            for (int i = 0; i < r.Packages.Count; i++)
                            {
                                r.Packages.ElementAt(i).TrackNumber = tracknumbers[i];
                            }
                            r.SuccessPaid = true;
                            attachmentPaths.Add(attachment);
                        }
                        else
                        {
                            //错误保存在Errors里面
                            r.SuccessPaid = false;
                            StringBuilder errors = new StringBuilder();
                            foreach (string error in labelResponse_leader.Errors)
                            {
                                errors.Append(error + ";");
                            }

                            r.Errors = errors.ToString();
                        }

                        /*
                        //根据包裹号下载pdf
                        string[] packagenumbers = wm_ordernumber.Split(',');
                        LabelResponse labelResponse_package = client.GetLabelByPackgeNumber(username, password, packagenumbers[0]);
                        if (labelResponse_package.Errors == null)
                        {
                            byte[] byt = labelResponse_package.Label;
                            File.WriteAllBytes(AppDomain.CurrentDomain.BaseDirectory + "\\pdf\\" + packagenumbers[0] + ".pdf", byt);

                        }
                        else
                        {
                            //错误保存在Errors里面
                        }
                        //根据国际单号下载pdf
                        string[] tracknumbers = tracknumber.Split(',');
                        LabelResponse labelResponse_track = client.GetLabelByTrackNumber(username, password, tracknumbers[0]);
                        if (labelResponse_track.Errors == null)
                        {
                            byte[] byt = labelResponse_track.Label;
                            File.WriteAllBytes(AppDomain.CurrentDomain.BaseDirectory + "\\pdf\\" + tracknumbers[0] + ".pdf", byt);

                        }
                        else
                        {
                            //错误保存在Errors里面
                        }
                         


                    }
                    //如果出现错误
                    else
                    {
                        for (int i = 0; i < response.Errors.Length; i++)
                        {//错误列表
                            string error = response.Errors[i].ToString();
                        }
                        r.SuccessPaid = false;

                        StringBuilder errors = new StringBuilder();
                        foreach (string error in response.Errors)
                        {
                            errors.Append(error + ";");
                        }

                        r.Errors = errors.ToString();
                    }                    
                }
        */
            #endregion
            if (freePickupCost)
            {
                if (o.Service.PickUpCompany.Contains("999 Parcel") || o.Service.PickUpCompany.Contains("999Parcel"))
                {
                    o.PickupPrice = 0m;
                    o.UKMConsignmentNumber = timeStamp;
                }
            }
            o.HasPaid = true;
        }        
    }
}