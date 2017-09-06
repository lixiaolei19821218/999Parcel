<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CheckApply.aspx.cs" Inherits="Admin_CheckApply" MasterPageFile="~/Admin/Admin.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>充值审核</title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="body" runat="Server">
    <form runat="server">
        <div class="uitopb uitopb-border mt10" style="border-top:solid;">
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
                                    <asp:Button ID="ButtonPass" runat="server" Text="通过" CssClass="btn btn-1" OnClick="ButtonPass_Click" data-id="<%#Item.Id %>" />
                                    <asp:Button ID="ButtonRefuse" runat="server" Text="拒绝" CssClass="btn btn-1" OnClick="ButtonRefuse_Click" data-id="<%#Item.Id %>" />
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
                   string.Format("<a href='/Admin/CheckApply.aspx?page={0}' {1}>{2}</a>", i, i == CurrentPage ? "class='selected'" : "", i));
               }%>
        </div>
    </form>
</asp:Content>
