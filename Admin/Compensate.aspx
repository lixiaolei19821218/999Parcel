<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Compensate.aspx.cs" Inherits="Admin_Compensate" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>运费赔付补交 | 诚信物流-可靠,快捷,实惠</title>    
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
                <th class="tac">总额</th>
            </tr>
            <tr>
                <th class="tac">申报</th>
                <td class="tac"><%:Package.Weight %></td>
                <td class="tac"><%:Package.Length %></td>
                <td class="tac"><%:Package.Width %></td>
                <td class="tac"><%:Package.Height %></td>
                <td class="tac"><%:Package.FinalCost %></td>
            </tr>
            <tr>
                <th class="tac" style="vertical-align: middle;">实测</th>
                <td class="tac">
                   <input id="txtWeight" runat="server" type="number" style="width: 50px;" min="0.1" step="0.1"/></td>
                <td class="tac">
                    <input id="txtLength" runat="server" type="number" style="width: 50px;" min="0.1" step="0.1" /></td>
                <td class="tac">
                    <input id="txtWidth" runat="server" type="number" style="width: 50px;" min="0.1" step="0.1" /></td>
                <td class="tac">
                    <input id="txtHeight" runat="server" type="number" style="width: 50px;" min="0.1" step="0.1" /></td>
                <td class="tac"></td>
            </tr>
        </table>
        <hr />
        
        <div class="mg1">
            <a href="Parcel.aspx">返回已完成包裹</a>
            <div style="float:right;">
            <label runat="server" id="lbRepay" style="font-family: 'Microsoft YaHei UI';">运费补交</label><input type="number" id="sub" runat="server" style="width: 60px; margin-left: 5px; margin-right: 5px;" min="0.01" value="0.01" step="0.01" /><asp:Button runat="server" CssClass="btn btn-danger btn-small del" Style="margin-bottom: 3px; line-height: 1" Text="确定" ID="ButtonSub" OnClick="ButtonSub_Click" />
            <label runat="server" id="lbCompensate" style="margin-left: 20px; font-family: 'Microsoft YaHei UI';">运费赔付</label><input id="add" runat="server" type="number" style="width: 60px; margin-left: 5px; margin-right: 5px;" min="0.01" value="0.01" step="0.01"/><asp:Button runat="server" CssClass="btn btn-danger btn-small del" Style="margin-bottom: 3px; line-height: 1" Text="确定" ID="ButtonAdd" OnClick="ButtonAdd_Click" />
                    </div>
            </div>
    </form>
</asp:Content>
