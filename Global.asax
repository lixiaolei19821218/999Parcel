<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e) 
    {
        // 在应用程序启动时运行的代码
        BundleConfig.RegisterBundles(System.Web.Optimization.BundleTable.Bundles);
        ASP.App_Start.NinjectWebCommon.Start();

        System.Timers.Timer myTimer = new System.Timers.Timer(5000);

        myTimer.Elapsed += new System.Timers.ElapsedEventHandler(myTimer_Elapsed);

        myTimer.Enabled = true;

        myTimer.AutoReset = true;  
    }

    void myTimer_Elapsed(object source, System.Timers.ElapsedEventArgs e)
    {
        

    }
    
    
    void Application_End(object sender, EventArgs e) 
    {
        //  在应用程序关闭时运行的代码
        ASP.App_Start.NinjectWebCommon.Stop();
        
        //下面的代码是关键，可解决IIS应用程序池自动回收的问题  

        System.Threading.Thread.Sleep(1000);

        //这里设置你的web地址，可以随便指向你的任意一个aspx页面甚至不存在的页面，目的是要激发Application_Start  

        string url = "http://www.999parcel.com";

        System.Net.HttpWebRequest myHttpWebRequest = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(url);

        System.Net.HttpWebResponse myHttpWebResponse = (System.Net.HttpWebResponse)myHttpWebRequest.GetResponse();

        System.IO.Stream receiveStream = myHttpWebResponse.GetResponseStream();//得到回写的字节流  
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
