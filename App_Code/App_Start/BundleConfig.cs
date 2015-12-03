using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;

/// <summary>
/// BundleConfig 的摘要说明
/// </summary>
public class BundleConfig
{
	public BundleConfig()
	{
		//
		// TODO: 在此处添加构造函数逻辑
		//
	}

    public static void RegisterBundles(BundleCollection bundles)
    {        
        Bundle validation = new ScriptBundle("~/bundle/validation").Include("~/Scripts/jquery-{version}.js", "~/Scripts/jquery.validate.js", "~/Scripts/jquery.validate.unobtrusive.js");
        bundles.Add(validation);
    }
}