using Ninject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// DIConfiguration 的摘要说明
/// </summary>
public class DIConfiguration
{
	public DIConfiguration()
	{
		//
		// TODO: 在此处添加构造函数逻辑
		//
	}

    public static void SetupDI(IKernel kernel)
    {        
        kernel.Bind<IRepository>().To<Repository>().InSingletonScope();
    }
}