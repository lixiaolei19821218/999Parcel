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



    public static string HttpPost(string Url, string postDataStr)
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
            request = WebRequest.Create(posturl) as HttpWebRequest;
            CookieContainer cookieContainer = new CookieContainer();
            request.CookieContainer = cookieContainer;
            request.AllowAutoRedirect = true;
            request.Method = "POST";
            request.ContentType = "text/json";
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
            return string.Empty;
        }
    }



    public string HttpGet(string Url, string postDataStr)
    {

        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(Url + (postDataStr == "" ? "" : "?") + postDataStr);

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
}