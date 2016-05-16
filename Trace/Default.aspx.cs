﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class Trace_Default : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
       
    }

    public IEnumerable<TraceMessage> GetTraceMessages()
    {
        if (string.IsNullOrWhiteSpace(Request["txtTraceNumber"]))
        {
            return new List<TraceMessage>();
        }
        string traceNumber = Request["txtTraceNumber"];
        List<TraceMessage> traceMessages = new List<TraceMessage>(repo.Context.TraceMessages.Where(t => t.TraceNumber.Number == traceNumber));
        SFService.ExpressServiceClient sf = new SFService.ExpressServiceClient();//V3.2接口
        string xml = GetRouteXml(traceNumber);
        string checkword = ConfigurationManager.AppSettings["CheckWord"];
        string verifyCode1 = xml + checkword;
        string verifyCode = MD5Encrypt.MD5ToBase64String(verifyCode1);//生成verifyCode        
        string a = sf.sfexpressService(xml, verifyCode);
        XmlDocument x = new XmlDocument();
        x.LoadXml(a);
        if (x.ChildNodes[1].LastChild.ChildNodes.Count > 0)
        {
            foreach (XmlNode node in x.ChildNodes[1].LastChild.FirstChild.ChildNodes)
            {
                TraceMessage tm = new TraceMessage() { DateTime = DateTime.Parse(node.Attributes["accept_time"].Value), Message = string.Format("{0}[{1}]", node.Attributes["remark"].Value, node.Attributes["accept_address"].Value) };
                traceMessages.Add(tm);
            }
        }
        return traceMessages.OrderBy(t => t.DateTime);
    }

    ///<summary>
    ///路由查询报文
    ///</summary>
    ///<returns></returns>
    public string GetRouteXml(string traceNumber = "755123456789")
    {
        StringBuilder strXML = new StringBuilder();
        strXML.Append("<Request service='RouteService' lang='zh-CN'>");//申请服务及语言
        strXML.Append(GetHead(ConfigurationManager.AppSettings["JRM"])); //客户编码 V3.2
        strXML.Append(string.Format("<Body><RouteRequest tracking_type='1'  method_type= '1'  tracking_number='{0}'/>", traceNumber));
        strXML.Append("</RouteRequest></Body></Request>");
        return strXML.ToString();
    }

    /// <summary>
    /// 获取头文件（WebService）
    /// </summary>
    /// <param name="ClientNo">接口编码或客户编码</param>
    /// <param name="Checkword">校验码</param>
    /// <returns>报头文件</returns>
    public string GetHead(string ClientNo)
    {
        StringBuilder strXML = new StringBuilder();
        strXML.Append("<Head>" + ClientNo + "</Head>");
        return strXML.ToString();
    }
}

class MD5Encrypt
{
    /// <summary>
    /// MD5加密
    /// </summary>
    /// <param name="str">需加密的字符串</param>
    /// <returns>加密后的字符</returns>
    public static string Md5Encryption(string str)
    {
        MD5 md5 = new MD5CryptoServiceProvider();
        byte[] data = System.Text.Encoding.Unicode.GetBytes(str);
        byte[] todata = md5.ComputeHash(data);
        string bytestr = null;
        for (int i = 0; i < todata.Length; i++)
        {
            bytestr += todata[i].ToString("x");
        }
        return bytestr;
    }


    /// <summary>
    /// 加密
    /// </summary>
    /// <param name="str">需加密的字符串</param>
    /// <returns>加密后的字符</returns>
    public static string MD5ToBase64String(string str)
    {
        MD5 md5 = new MD5CryptoServiceProvider();
        byte[] MD5 = md5.ComputeHash(System.Text.Encoding.UTF8.GetBytes(str));//MD5(注意UTF8编码)
        string result = Convert.ToBase64String(MD5, 0, MD5.Length);//Base64
        return result;
    }
    ///   <summary>
    ///   给一个字符串进行MD5加密
    ///   </summary>
    ///   <param   name="strText">待加密字符串</param>
    ///   <returns>加密后的数组</returns>
    public static byte[] MD5EncryptEX(string strText)
    {
        MD5 md5 = new MD5CryptoServiceProvider();
        byte[] result = md5.ComputeHash(System.Text.Encoding.UTF8.GetBytes(strText));
        return result;
    }
    /// <summary>
    /// Base64 编码
    /// </summary>
    /// <param name="bytedata">待编码数组</param>
    /// <returns>编码后字符串</returns>
    public static string ToBase64String(byte[] bytedata)
    {
        string strPath = Convert.ToBase64String(bytedata, 0, bytedata.Length);
        return strPath;
    }
}