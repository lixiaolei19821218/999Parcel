using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_TraceEdit : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ListBoxAdded.DataSource = repo.Context.TraceNumbers.ToList();
            ListBoxAdded.DataBind();
        }
        
    }
    protected void ButtonAdd_Click(object sender, EventArgs e)
    {
        TraceNumber traceNumber = new TraceNumber();
        if (string.IsNullOrWhiteSpace(txtTraceNumber.Value))
        {

        }
        traceNumber.Number = txtTraceNumber.Value;
        repo.Context.TraceNumbers.Add(traceNumber);
        repo.Context.SaveChanges();
        ListBoxAdded.DataBind();
        this.Page_Load(sender, e);
    }
    protected void ListBoxAdded_SelectedIndexChanged(object sender, EventArgs e)
    {
        int id = int.Parse(ListBoxAdded.SelectedItem.Value);
        TraceNumber traceNumber = repo.Context.TraceNumbers.Find(id);
        GridViewMessage.DataSource = traceNumber.TraceMessages;
        GridViewMessage.DataBind();
        this.Page_Load(sender, e);
    }
}