using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Trace_Default : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
       
    }

    public IEnumerable<TraceMessage> GetTraceMessages()
    {

        string traceNumber = Request["txtTraceNumber"] == null ? string.Empty : Request["txtTraceNumber"];
        return repo.Context.TraceMessages.Where(t => t.TraceNumber.Number == traceNumber);

    }
}