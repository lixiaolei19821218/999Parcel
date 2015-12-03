<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RechargeList.aspx.cs" Inherits="accounts_UserCentre_RechargeList" MasterPageFile="~/accounts/UserCentre/UserCentre.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>充值记录</title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="body" runat="Server">
    <h2>充值明细</h2>
    <div class="sub-nav">
        <span class="rt">充值<em>£<%:GetTotalApplyMoney() %></em>，剩余<em>£0</em>(赠送<em>£0</em>)</span>
        <a href="OrderRecords.aspx" class="back">返回</a>
    </div>
    <div class="uitopb uitopb-border mt10">
        <div class="table-div">
            <table class="table-list">
                <tr>
                    <th>方式</th>
                    <th>金额(£)</th>
                    <th>凭证</th>
                    <th>时间</th>
                    <th>处理</th>
                </tr>
                <asp:Repeater runat="server" SelectMethod="GetPageApplys" ItemType="RechargeApply">
                    <ItemTemplate>
                        <tr>
                            <td><%#Item.RechargeChannel.Name %></td>
                            <td><%#Item.ApprovedAmount.HasValue? Item.ApprovedAmount.Value.ToString() : "－" %></td>
                            <td>
                                <a href="<%#Item.Evidence %>" target="_blank" title="付款凭证"><%#string.IsNullOrEmpty(Item.Evidence) ? string.Empty: "付款凭证" %></a><br />
                            </td>
                            <td><%#Item.Time %></td>
                            <td><%#Item.IsApproved.HasValue ? (Item.IsApproved.Value ? "<span style=\"color:green\">审核通过</span>" : "<span style=\"color:red\">审核失败</span>") : "审核中" %></td>
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
               string.Format("<a href='/accounts/UserCentre/RechargeList.aspx?page={0}' {1}>{2}</a>", i, i == CurrentPage ? "class='selected'" : "", i));
           }%>
    </div>
</asp:Content>
