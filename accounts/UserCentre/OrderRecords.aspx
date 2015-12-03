<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderRecords.aspx.cs" Inherits="accounts_UserCentre_OrderRecords" MasterPageFile="~/accounts/UserCentre/UserCentre.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>账号消费记录</title>
   
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="body" runat="Server">
    <h2>账户金额</h2>
    <div class="sub-nav">
        <a href="Recharge.aspx" class="add">我要充值</a>
        <a href="RechargeList.aspx" class="pay">充值明细</a>
    </div>
    <div class="uitopb uitopb-border mt10">
        <div class="table-div">
            <table class="table-list">
                <tr>
                    <th>类型</th>
                    <th>金额(£)</th>
                    <th>余额(£)</th>
                    <th>时间</th>
                </tr>
                <tr>
                    <td colspan="4">暂无数据</td>
                </tr>
            </table>
        </div>
    </div>
    <div class="pager"></div>
</asp:Content>
