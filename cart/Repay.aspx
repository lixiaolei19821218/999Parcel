<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Repay.aspx.cs" Inherits="cart_Repay" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>补交明细 | 诚信物流-可靠,快捷,实惠</title>    
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <br />
    <form runat="server" method="post" style="padding-top: 0px;">
        <fieldset>
            <legend>发件人：<%:Package.Recipient.Order.SenderName%><span style="float: right;"><%:Package.TrackNumber%></span></legend>

            <ul>
                <li>城市：<%:Package.Recipient.Order.SenderCity %></li>
                <li>邮编：<%:Package.Recipient.Order.SenderZipCode %></li>
                <li>地址：<%:Package.Recipient.Order.SenderAddress1 %> <%:Package.Recipient.Order.SenderAddress2 %> <%:Package.Recipient.Order.SenderAddress3 %></li>
                <li>电话：<%:Package.Recipient.Order.SenderPhone %></li>
            </ul>
        </fieldset>
        <fieldset>
            <legend>收件人：<%:Package.Recipient.Name %></legend>
            <ul>
                <li>城市：<%:Package.Recipient.City %></li>
                <li>地址：<%:Package.Recipient.Address %></li>
                <li>手机：<%:Package.Recipient.PhoneNumber %></li>
                <li>邮编：<%:Package.Recipient.ZipCode %></li>
            </ul>
        </fieldset>
        <table class="table table-orders" style="margin-top: 10px">
            <tr>
                <th class="tac"></th>
                <th class="tac">重量</th>
                <th class="tac">长度</th>
                <th class="tac">宽度</th>
                <th class="tac">高度</th>
                <th class="tac"></th>
            </tr>
            <tr>
                <th class="tac">申报</th>
                <td class="tac"><%:Package.Weight %></td>
                <td class="tac"><%:Package.Length %></td>
                <td class="tac"><%:Package.Width %></td>
                <td class="tac"><%:Package.Height %></td>
                <td class="tac">运费：£<%:Package.FinalCost.ToString("F2") %></td>
            </tr>
            <tr>
                <th class="tac" style="vertical-align: middle;">实测</th>
                <td class="tac"><%:Package.Repay.Weight %></td>
                <td class="tac"><%:Package.Repay.Length %></td>
                <td class="tac"><%:Package.Repay.Width %></td>
                <td class="tac"><%:Package.Repay.Height %></td>
                <td class="tac">补交：£<%:Package.Repay.Value.ToString("F2") %></td>
            </tr>
        </table>
        <hr />
        <div class="mg1">
            <a href="Parcel.aspx">返回已完成包裹</a>            
        </div>        
    </form>
</asp:Content>
