<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProcessedApplys.aspx.cs" Inherits="Admin_ProcessedApplys" MasterPageFile="~/Admin/Admin.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>已处理申请</title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="body" runat="Server">
    <form runat="server">
        <div class="uitopb uitopb-border mt10">
            <div class="table-div">
                <table class="table-list">
                    <tr>
                        <th>账号</th>
                        <th>方式</th>
                        <th>申请金额(£)</th>
                        <th>凭证</th>
                        <th>时间</th>
                        <th>处理</th>
                    </tr>
                    <asp:Repeater runat="server" SelectMethod="GetPageApplys" ItemType="RechargeApply">
                        <ItemTemplate>
                            <tr>
                                <td><%#Item.User %></td>
                                <td><%#Item.RechargeChannel.Name %></td>
                                <td><%#Item.ApplyAmount %></td>
                                <td>
                                    <a href="<%#Item.Evidence %>" target="_blank" title="付款凭证"><%#string.IsNullOrEmpty(Item.Evidence) ? string.Empty: "付款凭证" %></a><br />
                                </td>
                                <td><%#Item.Time %></td>
                                <td>
                                    <%#Item.IsApproved.Value ? "<span style=\"color:green\">审核通过</span>" : "<span style=\"color:red\">已拒绝</span>" %>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
            </div>
        </div>
        <div class="pager">
            <% for (int i = 1; i <= MaxPage; i++)
               {
                   Response.Write(
                   string.Format("<a href='/Admin/ProcessedApplys.aspx?page={0}' {1}>{2}</a>", i, i == CurrentPage ? "class='selected'" : "", i));
               }%>
        </div>
    </form>
</asp:Content>
