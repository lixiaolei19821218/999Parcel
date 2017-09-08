<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProcessedApplys.aspx.cs" Inherits="Admin_ProcessedApplys" MasterPageFile="~/Admin/Admin.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>已处理申请</title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="body" runat="Server">
    <form runat="server">
        <div class="uitopb uitopb-border mt10" style="border-top:solid;">
            <div class="table-div">
                <table class="table-list" style="word-break: keep-all;">
                    <tr>
                        <th>申请单号</th>
                        <th>账号</th>
                        <th>方式</th>
                        <th>金额(£)</th>
                        <th>凭证</th>
                        <th>申请时间</th>
                        <th>审批结果</th>
                        <th>管理员</th>
                        <th>审批时间</th>
                    </tr>
                    <asp:Repeater runat="server" SelectMethod="GetPageApplys" ItemType="RechargeApply">
                        <ItemTemplate>
                            <tr>
                                <td><%#string.Format("{0:d9}", Item.Id) %></td>
                                <td><%#Item.User %></td>
                                <td><%#Item.RechargeChannel.Name %></td>
                                <td><%#Item.ApplyAmount %></td>
                                <td>
                                    <a href="<%#Item.Evidence %>" target="_blank" title="付款凭证"><%#string.IsNullOrEmpty(Item.Evidence) ? string.Empty: "付款凭证" %></a><br />
                                </td>
                                <td><%#Item.Time.HasValue ? Item.Time.Value.ToString("yyyy-MM-dd HH:mm") : "" %></td>
                                <td>
                                    <%#Item.IsApproved.Value ? "<span style=\"color:green\">审核通过</span>" : "<span style=\"color:red\">已拒绝</span>" %>
                                </td>
                                <td><%#Item.Approver %></td>
                                <td><%#Item.ApproveTime.HasValue ? Item.ApproveTime.Value.ToString("yyyy-MM-dd HH:mm") : "" %></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
            </div>
        </div>
        <div class="pager">
            <% for (int i = StartPage; i < GetPageCount(); i++)
               {
                   Response.Write(
                   string.Format("<a href='/Admin/ProcessedApplys.aspx?page={0}&startpage={3}' {1} Style=\"vertical-align: middle;\">{2}</a>", i, i == CurrentPage ? "class='selected'" : "", i, StartPage));
               }%>
            <asp:ImageButton ID="btnNext" ImageUrl="/static/images/icon/next.jpg" Width="20" Height="20" runat="server" Style="vertical-align: middle;" OnClick="btnNext_Click" />
        </div>
    </form>
</asp:Content>
