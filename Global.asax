<%@ Application Language="C#" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">

    System.Timers.Timer myTimer;
    string _999parcelBpost;
    string ukmailBpost;
    System.IO.StreamReader sr1, sr2;
    UK_ExpressEntities entities = new UK_ExpressEntities();
    
    void Application_Start(object sender, EventArgs e) 
    {
        // 在应用程序启动时运行的代码
        BundleConfig.RegisterBundles(System.Web.Optimization.BundleTable.Bundles);
        ASP.App_Start.NinjectWebCommon.Start();
        /*
        sr1 = new System.IO.StreamReader(HttpRuntime.AppDomainAppPath + "cart/999BpostMail.html");
        sr2 = new System.IO.StreamReader(HttpRuntime.AppDomainAppPath + "cart/UKMailBpostMail.html");
        _999parcelBpost = sr1.ReadToEnd();
        ukmailBpost = sr2.ReadToEnd();
        sr1.Close();
        sr2.Close();

        myTimer = new System.Timers.Timer(1000 * 60 * 5);

        myTimer.Elapsed += new System.Timers.ElapsedEventHandler(myTimer_Elapsed);

        myTimer.Enabled = true;

        myTimer.AutoReset = true;  */
    }

    void myTimer_Elapsed(object source, System.Timers.ElapsedEventArgs e)
    {
        myTimer.Enabled = false;
        GetNormalOrders();
        myTimer.Enabled = true;
    }
    
    public void GetNormalOrders()
    {     
        var orders = from o in entities.Orders where (o.HasPaid ?? false) && (o.Service.Name.Contains("Bpost") && o.SuccessPaid.HasValue == false) select o;

        if (orders.Count() != 0)
        {
            FtpWeb ftp = new FtpWeb("ftp://transfert.post.be/out", "999_parcels", "dkfoec36");
            string[] allFiles = ftp.GetFileList("*.*");
            if (allFiles != null)
            {
                foreach (Order order in orders)
                {
                    string path = HttpRuntime.AppDomainAppPath + "bpost_files/" + order.User;
                    if (!System.IO.Directory.Exists(path))
                    {
                        System.IO.Directory.CreateDirectory(path);
                    }
                    string resultFile = string.Format("m2m_result_cn09320000_09320000_{0}.txt", order.Id.ToString().PadLeft(5, '0'));
                    if (allFiles.Contains(resultFile))
                    {
                        ftp.Download(path, resultFile);
                        string file = System.IO.Path.Combine(path, resultFile);
                        if (!System.IO.File.Exists(file))
                        {
                            throw new Exception("从Bpost下载结果文件失败，请联系管理员。");
                        }
                        System.IO.StreamReader sr = new System.IO.StreamReader(file);
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
                entities.SaveChanges();                
            }
        }
        //entities.Dispose();        
    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  在应用程序关闭时运行的代码
        ASP.App_Start.NinjectWebCommon.Stop();
        
        //下面的代码是关键，可解决IIS应用程序池自动回收的问题  
        /*
        System.Threading.Thread.Sleep(1000);

        //这里设置你的web地址，可以随便指向你的任意一个aspx页面甚至不存在的页面，目的是要激发Application_Start  

        string url = "http://www.999parcel.com";

        System.Net.HttpWebRequest myHttpWebRequest = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(url);

        System.Net.HttpWebResponse myHttpWebResponse = (System.Net.HttpWebResponse)myHttpWebRequest.GetResponse();

        System.IO.Stream receiveStream = myHttpWebResponse.GetResponseStream();//得到回写的字节流  */
    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // 在出现未处理的错误时运行的代码

    }

    void Session_Start(object sender, EventArgs e) 
    {
        // 在新会话启动时运行的代码

    }

    void Session_End(object sender, EventArgs e) 
    {
        // 在会话结束时运行的代码。 
        // 注意: 只有在 Web.config 文件中的 sessionstate 模式设置为
        // InProc 时，才会引发 Session_End 事件。如果会话模式设置为 StateServer
        // 或 SQLServer，则不引发该事件。

    }
   

     
</script>
