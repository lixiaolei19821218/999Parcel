using ICSharpCode.SharpZipLib.Zip;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;

/// <summary>
/// HttpHelper 的摘要说明
/// </summary>
public static class HttpHelper
{
    public static string HttpPost(string postUrl, string postData, string authorization = "", string etoApikey = "")
    {
        Stream outstream = null;
        Stream instream = null;
        StreamReader sr = null;
        HttpWebResponse response = null;
        HttpWebRequest request = null;
        Encoding encoding = System.Text.Encoding.GetEncoding("UTF-8");
        byte[] data = encoding.GetBytes(postData);
        // 准备请求...  
        try
        {
            // 设置参数  
            request = WebRequest.Create(postUrl) as HttpWebRequest;
            CookieContainer cookieContainer = new CookieContainer();
            if (authorization != "")
            {
                request.Headers.Add("Authorization", authorization);
            }
            if (etoApikey != "")
            {
                request.Headers.Add("eto_apikey", etoApikey);
            }
            request.CookieContainer = cookieContainer;
            request.AllowAutoRedirect = true;
            request.Method = "POST";
            request.Timeout = 1000 * 60 * 5;
            request.ContentType = "application/json";
            request.Headers.Add("charset", "utf-8");
            request.ContentLength = data.Length;
            
            outstream = request.GetRequestStream();
            outstream.Write(data, 0, data.Length);
            outstream.Close();
            //发送请求并获取相应回应数据  
            response = request.GetResponse() as HttpWebResponse;
            //直到request.GetResponse()程序才开始向目标网页发送Post请求  
            instream = response.GetResponseStream();
            sr = new StreamReader(instream, encoding);
            //返回结果网页（html）代码  
            string content = sr.ReadToEnd();
            string err = string.Empty;
            return content;
        }
        catch (Exception ex)
        {
            string err = ex.Message;
            return err;
        }
    }



    public static string HttpGet(string Url)
    {

        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(Url);

        request.Method = "GET";

        request.ContentType = "text/html;charset=UTF-8";



        HttpWebResponse response = (HttpWebResponse)request.GetResponse();

        Stream myResponseStream = response.GetResponseStream();

        StreamReader myStreamReader = new StreamReader(myResponseStream, Encoding.GetEncoding("utf-8"));

        string retString = myStreamReader.ReadToEnd();

        myStreamReader.Close();

        myResponseStream.Close();



        return retString;

    }

    public static string Download(string url, string username)
    {
        
        System.Net.HttpWebRequest request = (System.Net.HttpWebRequest)System.Net.HttpWebRequest.Create(url);
        System.Net.HttpWebResponse response = (System.Net.HttpWebResponse)request.GetResponse();
        long totalBytes = response.ContentLength;
        System.IO.Stream st = response.GetResponseStream();
        string folder = string.Format("{0}files\\PF\\{1}", HttpRuntime.AppDomainAppPath, username);
        if (!Directory.Exists(folder))
        {
            Directory.CreateDirectory(folder);
        }
        string filename = string.Format("{0}\\{1}", folder, request.RequestUri.Segments.Last());        
        System.IO.Stream so = new System.IO.FileStream(filename, System.IO.FileMode.Create);
        long totalDownloadedByte = 0;
        byte[] by = new byte[1024];
        int osize = st.Read(by, 0, (int)by.Length);
        while (osize > 0)
        {
            totalDownloadedByte = osize + totalDownloadedByte;
            so.Write(by, 0, osize);
            osize = st.Read(by, 0, (int)by.Length);
        }
        so.Close();
        st.Close();
        return filename; 
    }

    public static string ZipFiles(List<string> files, string username, string id)
    {
        MemoryStream ms = new MemoryStream();
        byte[] buffer = null;

        using (ZipFile file = ZipFile.Create(ms))
        {
            file.BeginUpdate();
            file.NameTransform = new MyNameTransfom();//通过这个名称格式化器，可以将里面的文件名进行一些处理。默认情况下，会自动根据文件的路径在zip中创建有关的文件夹。

            foreach (string pdf in files)
            {
                file.Add(pdf);
            }

            file.CommitUpdate();

            buffer = new byte[ms.Length];
            ms.Position = 0;
            ms.Read(buffer, 0, buffer.Length);
        }

        string folder = string.Format("", HttpRuntime.AppDomainAppPath, username);        
        string zip = string.Format("{0}files\\PF\\{1}\\{2}.zip", HttpRuntime.AppDomainAppPath, username, id);

        FileStream fs = new FileStream(zip, FileMode.OpenOrCreate, FileAccess.ReadWrite);
        fs.Write(buffer, 0, buffer.Length);
        fs.Close();

        return string.Format("files/PF/{0}/{1}.zip", username, id);
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
}