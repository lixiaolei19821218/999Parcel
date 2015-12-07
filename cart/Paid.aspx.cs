using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class cart_Paid : System.Web.UI.Page
{
    private int pageSize = 30;

    private IEnumerable<Order> normalOrders;
    private IEnumerable<SheffieldOrder> sheffieldOrders;
    private decimal balance;
    private decimal totalPrice;
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
        if (!IsPostBack)
        {
            username = Membership.GetUser().UserName;
            apUser = repo.Context.aspnet_User.First(u => u.UserName == username);

            //normalOrders = from o in repo.Orders where o.User == username && !(o.IsSheffieldOrder ?? false) && (o.HasPaid ?? false) select o;
            normalOrders = GetNormalOrders();
            sheffieldOrders = from o in repo.Context.SheffieldOrders where o.User == username select o;

            balance = apUser.Balance;
            totalPrice = normalOrders.Sum(o => o.Cost.Value);
            //totalPrice = normalOrders.Sum(o => o.Cost.Value) + sheffieldOrders.Sum(so => so.Orders.Sum(o => o.Cost.Value));

            normalField.Visible = normalOrders.Count() != 0 ? true : false;
            sheffieldField.Visible = sheffieldOrders.Count() != 0 ? true : false;
        }
    }

    public IEnumerable<Order> GetNormalOrders()
    {
        var orders = from o in repo.Orders where o.User == username && !(o.IsSheffieldOrder ?? false) && (o.HasPaid ?? false) select o;        
        
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
                    }
                }
                repo.Context.SaveChanges();
            }            
        }        
        return orders;
    }

    public IEnumerable<Order> GetNoneSheffieldOrders()
    {        
        return normalOrders;
    }

    public IEnumerable<SheffieldOrder> GetSheffieldOrders()
    {        
        return sheffieldOrders;
    }

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
        if (o.Service.Name.Contains("Parcelforce Economy"))
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
        else//bpost
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
                return "<img height=18 width=18 style=\"margin-left:2px;\" src=\"../static/images/icon/t17.ico\" title=\"已发送到Bpost，请等待比利时邮政确认(约1个小时)\">";
            }
        }
    }
}