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
            List<TraceNumber> traceNumbers = repo.Context.TraceNumbers.ToList();
            traceNumbers.Reverse();
            ListBoxAdded.DataSource = traceNumbers;
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
                        List<TraceNumber> traceNumbers = repo.Context.TraceNumbers.ToList();
                        traceNumbers.Reverse();
                        ListBoxAdded.DataSource = traceNumbers;
                        ListBoxAdded.DataBind();
                        txtTraceNumber.Value = null;
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
                    GridViewMessage.DataSource = repo.Context.TraceNumbers.Find(int.Parse(ListBoxAdded.Items[selectedIndices[0]].Value)).TraceMessages.Reverse();
                    GridViewMessage.DataBind();
                }                
            }
        }
    }


    protected void ListBoxAdded_SelectedIndexChanged(object sender, EventArgs e)
    {
        int id = int.Parse(ListBoxAdded.SelectedItem.Value);
        TraceNumber traceNumber = repo.Context.TraceNumbers.Find(id);
        GridViewMessage.DataSource = traceNumber.TraceMessages.Reverse();
        GridViewMessage.DataBind();
        GridViewMessage.Attributes.Add("curentTrackNumberId", id.ToString());
    }

    protected void GridViewMessage_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {       
        int numberId = int.Parse(GridViewMessage.Attributes["curentTrackNumberId"]);
        TraceNumber traceNumber = repo.Context.TraceNumbers.Find(numberId);
        int messageId =  Convert.ToInt32(GridViewMessage.DataKeys[e.RowIndex]["Id"].ToString());
        TraceMessage traceMessage = repo.Context.TraceMessages.Find(messageId);
        traceNumber.TraceMessages.Remove(traceMessage);
        repo.Context.TraceMessages.Remove(traceMessage);
        repo.Context.SaveChanges();
        GridViewMessage.DataSource = traceNumber.TraceMessages.Reverse();
        GridViewMessage.DataBind();
    }   
   
    protected void GridViewMessage_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridViewMessage.EditIndex = -1;
        int numberId = int.Parse(GridViewMessage.Attributes["curentTrackNumberId"]);
        TraceNumber traceNumber = repo.Context.TraceNumbers.Find(numberId);
        GridViewMessage.DataSource = traceNumber.TraceMessages.Reverse();
        GridViewMessage.DataBind();
    }

    protected void GridViewMessage_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int messageId = Convert.ToInt32(GridViewMessage.DataKeys[e.RowIndex]["Id"].ToString());
        TraceMessage traceMessage = repo.Context.TraceMessages.Find(messageId);
        traceMessage.DateTime = DateTime.Parse(((TextBox)GridViewMessage.Rows[e.RowIndex].Cells[0].Controls[1]).Text.Trim());
        traceMessage.Message = ((TextBox)GridViewMessage.Rows[e.RowIndex].Cells[1].Controls[1]).Text.Trim();
        repo.Context.SaveChanges(); 
        GridViewMessage.EditIndex = -1;
        int numberId = int.Parse(GridViewMessage.Attributes["curentTrackNumberId"]);
        TraceNumber traceNumber = repo.Context.TraceNumbers.Find(numberId);
        GridViewMessage.DataSource = traceNumber.TraceMessages.Reverse();
        GridViewMessage.DataBind();
       
    }

    protected void GridViewMessage_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridViewMessage.EditIndex = e.NewEditIndex;
        int numberId = int.Parse(GridViewMessage.Attributes["curentTrackNumberId"]);
        TraceNumber traceNumber = repo.Context.TraceNumbers.Find(numberId);
        GridViewMessage.DataSource = traceNumber.TraceMessages.Reverse();
        GridViewMessage.DataBind();
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        int[] selectedIndices = ListBoxAdded.GetSelectedIndices();
        if (selectedIndices != null)
        {
            for (int i = 0; i < selectedIndices.Length; i++)
            {
                int id = int.Parse(ListBoxAdded.Items[selectedIndices[i]].Value);
                TraceNumber traceNumber = repo.Context.TraceNumbers.Find(id);
                repo.Context.TraceMessages.RemoveRange(traceNumber.TraceMessages);                
                repo.Context.TraceNumbers.Remove(traceNumber);
            }
            repo.Context.SaveChanges();
            List<TraceNumber> traceNumbers = repo.Context.TraceNumbers.ToList();
            traceNumbers.Reverse();
            ListBoxAdded.DataSource = traceNumbers;            
            ListBoxAdded.DataBind();
            ListBoxAdded.SelectedIndex = 0;
            if (ListBoxAdded.SelectedValue != null)
            {
                TraceNumber tn = repo.Context.TraceNumbers.Find(int.Parse(ListBoxAdded.SelectedValue));
                GridViewMessage.DataSource = tn.TraceMessages.Reverse();
                GridViewMessage.DataBind();
            }
            else
            {
                GridViewMessage.DataSource = null;
                GridViewMessage.DataBind();
            }
        }   
    }

    protected void btnQuery_Click(object sender, EventArgs e)
    {
        if (!string.IsNullOrWhiteSpace(txtQuery.Value))
        {
            TraceNumber traceNumber = repo.Context.TraceNumbers.Where(t => t.Number == txtQuery.Value.Trim()).FirstOrDefault();
            if (traceNumber != null)
            {
                List<TraceNumber> traceNumbers = repo.Context.TraceNumbers.ToList();
                traceNumbers.Reverse();
                ListBoxAdded.SelectedIndex = traceNumbers.IndexOf(traceNumber);
                GridViewMessage.DataSource = traceNumber.TraceMessages.Reverse();
                GridViewMessage.DataBind();
            }
            else
            {
                labelQueryError.Text = string.Format("没有查找到运单{0}", txtQuery.Value.Trim());
                labelQueryError.Visible = true;
            }
        }
        else
        {
            labelQueryError.Text = "请输入正确的订单号";
            labelQueryError.Visible = true;
        }
    }
}