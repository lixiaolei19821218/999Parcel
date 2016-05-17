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
        else
        {
            if (Request.Form["btnAddTraceNumber"] != null)
            {
                TraceNumber traceNumber = new TraceNumber();
                if (string.IsNullOrWhiteSpace(txtTraceNumber.Value))
                {
                    labelError.Visible = true;
                    labelError.Text = "请输入运单号";
                }
                else
                {
                    if (repo.Context.TraceNumbers.Any(t => t.Number == txtTraceNumber.Value))
                    {
                        labelError.Visible = true;
                        labelError.Text = string.Format("已存在运单号为{0}的运单", txtTraceNumber.Value);
                    }
                    else
                    {
                        traceNumber.Number = txtTraceNumber.Value;
                        repo.Context.TraceNumbers.Add(traceNumber);
                        repo.Context.SaveChanges();
                        ListBoxAdded.DataSource = repo.Context.TraceNumbers.ToList();
                        ListBoxAdded.DataBind();
                    }
                }
            }
            if (Request.Form["btnAddTraceMessage"] != null)
            {                
                DateTime dateTime;
                try
                {
                    dateTime = DateTime.Parse(txtDateTime.Value);
                }
                catch
                {
                    dateTime = DateTime.Now;
                }                
                string message = txtMessage.Value;
                int[] selectedIndices = ListBoxAdded.GetSelectedIndices();
                if (selectedIndices != null)
                {
                    for (int i = 0; i < selectedIndices.Length; i++)
                    {
                        int id = int.Parse(ListBoxAdded.Items[selectedIndices[i]].Value);
                        TraceNumber traceNumber = repo.Context.TraceNumbers.Find(id);
                        TraceMessage traceMessage = new TraceMessage() { DateTime = dateTime, Message = message };
                        traceNumber.TraceMessages.Add(traceMessage);
                    }
                    repo.Context.SaveChanges();
                    GridViewMessage.DataSource = repo.Context.TraceNumbers.Find(int.Parse(ListBoxAdded.Items[selectedIndices[0]].Value)).TraceMessages;
                    GridViewMessage.DataBind();
                }                
            }
        }
    }


    protected void ListBoxAdded_SelectedIndexChanged(object sender, EventArgs e)
    {
        int id = int.Parse(ListBoxAdded.SelectedItem.Value);
        TraceNumber traceNumber = repo.Context.TraceNumbers.Find(id);
        GridViewMessage.DataSource = traceNumber.TraceMessages;
        GridViewMessage.DataBind();
        GridViewMessage.Attributes.Add("curentTrackNumberId", id.ToString());
    }

    protected void GridViewMessage_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int numberId = int.Parse(GridViewMessage.Attributes["curentTrackNumberId"]);
        TraceNumber traceNumber = repo.Context.TraceNumbers.Find(numberId);
        int messageId = int.Parse(e.Values["Id"].ToString());
        TraceMessage traceMessage = repo.Context.TraceMessages.Find(messageId);
        traceNumber.TraceMessages.Remove(traceMessage);
        repo.Context.TraceMessages.Remove(traceMessage);
        repo.Context.SaveChanges();
        GridViewMessage.DataSource = traceNumber.TraceMessages;
        GridViewMessage.DataBind();
    }

    protected void GridViewMessage_RowEditing(object sender, GridViewEditEventArgs e)
    {

    }

    // The id parameter name should match the DataKeyNames value set on the control
    public void GridViewMessage_DeleteItem(int id)
    {

    }
}