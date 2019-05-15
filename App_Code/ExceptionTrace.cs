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
        string innerException = string.Empty;
        if (ex.InnerException != null)
        {
            innerException = ex.InnerException.Message;
        }
        sw.WriteLine("InnerException: " + innerException);
        sw.WriteLine();
        sw.Close();
    }
}