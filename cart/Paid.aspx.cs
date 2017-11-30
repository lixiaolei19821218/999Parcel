using ICSharpCode.SharpZipLib.Zip;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class cart_Paid : System.Web.UI.Page
{
    System.IO.StreamReader sr1, sr2;
    string _999parcelBpost;
    string ukmailBpost;

    private int pageSize = 20;
    public int PageSpan
    {
        get
        {
            return 10;
        }
    }

    private IEnumerable<Order> normalOrders;
    
    private decimal balance;
    //private decimal totalPrice;
    private string username;
    private aspnet_User apUser;

    [Ninject.Inject]
    public IRepository repo
    {
        get;
        set;
    }
   
    protected void Page_Load(object sender, EventArgs e)
    {
        //if (!IsPostBack)
        {
            username = Membership.GetUser().UserName;
            apUser = repo.Context.aspnet_User.First(u => u.UserName == username);
            normalOrders = GetNormalOrders();
            balance = apUser.Balance;
            //totalPrice = normalOrders.Sum(o => o.Cost.Value); 

            btnNext.Visible = MaxPage > PageSpan;            
        }
    }

    public IEnumerable<Order> GetNormalOrders()
    {
        sr1 = new System.IO.StreamReader(HttpRuntime.AppDomainAppPath + "cart/999BpostMail.html");
        sr2 = new System.IO.StreamReader(HttpRuntime.AppDomainAppPath + "cart/UKMailBpostMail.html");
        _999parcelBpost = sr1.ReadToEnd();
        ukmailBpost = sr2.ReadToEnd();
        sr1.Close();
        sr2.Close();
      
        var orders = from o in repo.Orders where o.User == username && (o.HasPaid ?? false) select o;
        return orders;
        //var o0 = orders.Last();
        //return orders;
        if (!orders.All(o => o.SuccessPaid.HasValue))
        {
            FtpWeb ftp = new FtpWeb("ftp://transfert.post.be/out", "999_parcels", "dkfoec36");
            string path = HttpRuntime.AppDomainAppPath + "bpost_files/" + username;
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }

            string[] allFiles = ftp.GetFileList("*.*");
            if (allFiles != null)
            {
                foreach (Order order in orders.Where(o => o.Service.Name.Contains("Bpost") && !o.SuccessPaid.HasValue))
                {
                    string resultFile = string.Format("m2m_result_cn09320000_09320000_{0}.txt", order.Id.ToString().PadLeft(5, '0'));
                    if (allFiles.Contains(resultFile))
                    {
                        ftp.Download(path, resultFile);
                        string file = Path.Combine(path, resultFile);
                        if (!File.Exists(file))
                        {
                            throw new Exception("从Bpost下载结果文件失败，请联系管理员。");
                        }
                        StreamReader sr = new StreamReader(file);
                        string header = sr.ReadLine();
                        string status = header.Split('|')[5];
                        List<string> attachedFiles = new List<string>();

                        if (status == "SUCCES")
                        {
                            foreach (Recipient r in order.Recipients)
                            {
                                foreach (Package p in r.Packages)
                                {
                                    string line = sr.ReadLine();
                                    if (line.Contains("BB001"))
                                    {
                                        string s = line.Split('|')[2];
                                        if (s == "OK")
                                        {
                                            p.Status = "SUCCESS";
                                            p.Pdf = Bpost.GeneratePdf(p, line.Split('|')[1]);
                                            attachedFiles.Add(HttpRuntime.AppDomainAppPath + p.Pdf);
                                        }
                                        else
                                        {
                                            p.Status = "FAIL";
                                            p.Response = "Bpost returned a error message.";
                                        }
                                    }
                                }
                                r.SuccessPaid = r.Packages.All(p => p.Status == "SUCCESS");
                            }
                            order.SuccessPaid = order.Recipients.All(r => r.SuccessPaid.Value);
                        }
                        else
                        {
                            order.SuccessPaid = false;
                            foreach (Recipient r in order.Recipients)
                            {
                                r.SuccessPaid = false;
                                foreach (Package p in r.Packages)
                                {
                                    p.Status = "FAIL";
                                }
                            }
                        }
                        sr.Close();
                        if (order.SuccessPaid ?? false)
                        {
                            string email = string.IsNullOrWhiteSpace(order.SenderEmail) ? Membership.GetUser(order.User).Email : order.SenderEmail;
                            string content;
                            if (order.Service.Name.Contains("UKMail"))
                            {
                                //写入UK Mail取件号
                                string[] v = ukmailBpost.Split(new string[] { "UKMAIL_NUMBER" }, StringSplitOptions.None);
                                content = v[0] + order.UKMConsignmentNumber + v[1] + order.UKMConsignmentNumber + v[2];
                            }
                            else
                            {
                                content = _999parcelBpost;
                            }
                            EmailService.SendEmailAync(email, "您在999Parcel的订单", content, attachedFiles.ToArray());
                        }
                    }
                }
                repo.Context.SaveChanges();
            }            
        }        
        return orders;
    }

    public string GetOrderTip(Order order)
    {
        ServiceView sv = new ServiceView(order.Service);
        Thread.CurrentThread.CurrentCulture = new CultureInfo("en-gb");
        return string.Format("取件费：{0:c2}，加固费：{1:c2}，快递费：{2:c2}， 折扣：-{3:c2}", order.PickupPrice, order.ReinforcePrice, order.DeliverPrice, order.Discount);
    }
    protected void NormalDetail_Click(object sender, EventArgs e)
    {
        int id;
        if (int.TryParse((sender as LinkButton).Attributes["data-id"], out id))
        {           
            Session.Add("id", id);
            Response.Redirect("/cart/OrderDetail.aspx");
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

    protected int StartPage
    {
        get
        {
            int page;
            page = int.TryParse(Request.QueryString["startpage"], out page) ? page : 1;
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

    protected string GetIcon(Order o)
    {
        if (o.Service.Name.Contains("Parcelforce Economy") || o.Service.Name.Contains("杂物包税") || o.Service.Name.Contains("自营奶粉包税"))
        {
            if (o.SuccessPaid ?? false)
            {
                return "<img src=\"../static/images/icon/onCorrect.gif\" title=\"发送成功\">";
            }
            else
            {
                return "<img src=\"../static/images/icon/onFocus.gif\" title=\"有发送失败的包裹\">";
            }
        }
        else if (o.Service.Name.Contains("Bpost"))
        {
            if (o.SuccessPaid.HasValue)
            {
                if (o.SuccessPaid.Value)
                {
                    return "<img src=\"../static/images/icon/onCorrect.gif\" title=\"发送成功\">";
                }
                else
                {
                    return "<img src=\"../static/images/icon/onFocus.gif\" title=\"有发送失败的包裹\">";
                }
            }
            else
            {
                return "<img height=18 width=18 style=\"margin-left:2px;\" src=\"../static/images/icon/t17.ico\" title=\"已发送到Bpost，请等待比利时邮政确认\">";
            }
        }        
        else
        {
            return string.Empty;
        }
    }

    protected void DownloadLabel_Click(object sender, EventArgs e)
    {
        int id;
        if (int.TryParse((sender as LinkButton).Attributes["data-id"], out id))
        {
            Order order = repo.Context.Orders.Find(id);

            MemoryStream ms = new MemoryStream();
            byte[] buffer = null;

            using (ZipFile file = ZipFile.Create(ms))
            {
                file.BeginUpdate();
                file.NameTransform = new MyNameTransfom();//通过这个名称格式化器，可以将里面的文件名进行一些处理。默认情况下，会自动根据文件的路径在zip中创建有关的文件夹。

                if (order.Service.Name.Contains("自营奶粉包税"))
                {
                    foreach (Recipient r in order.Recipients)
                    {
                        file.Add(Server.MapPath("~/" + r.WMLeaderPdf));
                    }
                }
                else if (order.Service.Name.Contains("Parcelforce"))
                {
                    foreach (Recipient r in order.Recipients)
                    {
                        foreach (Package p in r.Packages)
                        {
                            file.Add(Server.MapPath("~/" + p.Pdf));
                        }
                    }
                }

                file.CommitUpdate();

                buffer = new byte[ms.Length];
                ms.Position = 0;
                ms.Read(buffer, 0, buffer.Length);
            }

            Response.AddHeader("content-disposition", string.Format("attachment;filename={0}.zip", order.Id));
            Response.BinaryWrite(buffer);
            Response.Flush();
            Response.End();
        }
    }

    public class MyNameTransfom : ICSharpCode.SharpZipLib.Core.INameTransform
    {

        #region INameTransform 成员

        public string TransformDirectory(string name)
        {
            return null;
        }

        public string TransformFile(string name)
        {
            return Path.GetFileName(name);
        }

        #endregion
    }
   
    protected void btnNext_Click1(object sender, ImageClickEventArgs e)
    {
        if (StartPage + PageSpan <= MaxPage)
        {
            Response.Redirect(string.Format("/cart/Paid.aspx?page={0}&startpage={0}", StartPage + PageSpan));
        }
    }

    protected int GetPageCount()
    {
        if (StartPage + PageSpan < MaxPage + 1)
        {
            btnNext.Visible = true;
            return StartPage + PageSpan;
        }
        else
        {
            btnNext.Visible = false;
            return MaxPage + 1;
        }
    }

    protected void ReSend_Click(object sender, EventArgs e)
    {
        int id;
        if (int.TryParse((sender as LinkButton).Attributes["data-id"], out id))
        {
            Order o = repo.Context.Orders.Find(id);
            switch (o.Service.Name.Trim())
            {
                case "自营奶粉包税4罐 - 自送仓库":
                case "自营奶粉包税4罐 - 诚信物流取件":
                    SendToTTKD(o, TTKDType.FourTin);
                    break;
                case "自营奶粉包税6罐 - 自送仓库":
                case "自营奶粉包税6罐 - 诚信物流取件":
                    SendToTTKD(o, TTKDType.SixTin);
                    break;
                default:
                    break;
            }
            repo.Context.SaveChanges();
            Response.Redirect(Request.RawUrl);            
        }
    }

    public enum TTKDType { FourTin, SixTin }

    private void SendToTTKD(Order order, TTKDType type)
    {
        foreach (Recipient r in order.Recipients)
        {
            if (!(r.SuccessPaid ?? false))
            {
                StringBuilder data = new StringBuilder();
                string code = type == TTKDType.SixTin ? "001" : "003";
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

                string response = HttpHelper.HttpPost(string.Format("{0}/interface/make-order", ConfigurationManager.AppSettings["TTKDDomainName"]), data.ToString(), ConfigurationManager.AppSettings["Authorization"]);
                //order.UKMErrors = data.ToString() + " | " + response;
                //return;           
                //throw new Exception();                  

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

                    string mailBody = Application["MailBody"].ToString().Replace("999ParcelOrderNumber", string.Format("{0:d9}", r.Order.Id));
                    EmailService.SendEmailAync(string.IsNullOrEmpty(r.Order.SenderEmail) ? Membership.GetUser().Email : r.Order.SenderEmail, "您在999Parcel的订单" + string.Format("{0:d9}", r.Order.Id), mailBody, new string[] { System.AppDomain.CurrentDomain.BaseDirectory + path });
                }
                else
                {
                    r.SuccessPaid = false;
                    r.Errors = "TTKD: " + res.Msg;
                    foreach (Package p in r.Packages)
                    {
                        p.Status = "FAIL";
                        p.Response = "TTKD: " + res.Msg;
                        //p.Response = "信息错误，请联系客服";
                    }
                }
            }
        }
        order.SuccessPaid = order.Recipients.All(r => r.SuccessPaid ?? false);
    }

    public string GetTTKDLabel(string orderNum, TTKDType type)
    {
        string path = string.Empty;
        StringBuilder json = new StringBuilder("{");
        string code = type == TTKDType.SixTin ? "001" : "003";
        json.Append(string.Format("\"serviceCode\": \"{0}\",", code));
        json.Append(string.Format("\"userKey\": \"{0}\",", ConfigurationManager.AppSettings["TTKDUserKey"]));
        json.Append(string.Format("\"orderNum\": \"{0}\"}}", orderNum));
        string response = HttpHelper.HttpPost(string.Format("{0}/interface/order-label", ConfigurationManager.AppSettings["TTKDDomainName"]), json.ToString(), ConfigurationManager.AppSettings["Authorization"]);
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
}