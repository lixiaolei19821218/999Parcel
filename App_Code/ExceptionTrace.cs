using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ExceptionTrace
/// </summary>
public static class ExceptionTrace
{
    static ExceptionTrace()
    {
        
    }

    public static void PrintException(Exception ex)
    {
        StreamWriter sw = new StreamWriter(HttpRuntime.AppDomainAppPath + @"\ExceptionTrace\exception.txt", true);
        sw.WriteLine(DateTime.Now);
        sw.WriteLine("Message: " + ex.Message);
        sw.WriteLine("MInnerException: " + ex.InnerException.Message);
        sw.WriteLine();
        sw.Close();
    }
}