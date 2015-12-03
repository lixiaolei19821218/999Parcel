<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderDetail.aspx.cs" Inherits="cart_OrderDetail" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>包裹详情 | 诚信物流-可靠,快捷,实惠</title>
    <link href="../static/bootstrap3/css/bootstrap.min.css" rel="stylesheet">
    <script src="../static/bootstrap3/js/jquery-1.11.1.min.js"></script>
    <script src="../static/bootstrap3/js/bootstrap.min.js"></script>
    <script>$(function () {
    $("[data-toggle='popover']").popover({
        html: true
    });
});
    </script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sz16 bold colorb2" style="margin-top: 20px">
        订单详情
        <div style="float: right; font-size: smaller">
            <%:Order.Service.Name %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;订单号：<%:string.Format("{0:d9}", Session["id"]) %>
        </div>
    </div>

    <div style="margin-top: 15px; background-color: #fff; padding: 15px;">
        <fieldset>
            <legend>发件人：<%:Order.SenderName %><div style="float:right;font-size:medium;">费用：<%:Order.Cost.Value.ToString("c", CultureInfo.CreateSpecificCulture("en-GB")) %></div></legend>
            <ul>
                <li>城市：<%:Order.SenderCity %></li>
                <li>地址：<%:Order.SenderAddress1 + " " + Order.SenderAddress2 + " " + Order.SenderAddress3 %></li>
                <li>手机：<%:Order.SenderPhone%></li>
                <li>邮编：<%:Order.SenderZipCode%></li>
            </ul>
        </fieldset>
    </div>

    <div style="margin-top: 15px; margin-bottom:15px; background-color: #fff; padding: 15px; min-height: 600px;">
        <form runat="server" method="post" id="placeOrder" style="padding-top: 0px;">
            <asp:Repeater runat="server" ItemType="Recipient" SelectMethod="GetRecipients">
                <ItemTemplate>
                    <fieldset>
                        <legend>收件人：<%#Item.Name %><%# GetStatus(Item)%></legend>
                        <ul>
                            <li>城市：<%#Item.City %></li>
                            <li>地址：<%#Item.Address %></li>
                            <li>手机：<%#Item.PhoneNumber %></li>
                            <li>邮编：<%#Item.ZipCode %></li>
                            <table class="table table-orders" style="margin-top: 10px;">
                                <asp:Repeater runat="server" ItemType="Package" DataSource="<%#Item.Packages %>">
                                    <HeaderTemplate>
                                        <tr>
                                            <th class="tac">重量</th>
                                            <th class="tac">长度</th>
                                            <th class="tac">宽度</th>
                                            <th class="tac">高度</th>
                                            <th class="tac">总额</th>
                                            <th class="tac">状态</th>
                                            <th class="tac">跟踪号</th>
                                            <th class="tac">费用</th>
                                            <th class="tac">明细</th>
                                            <th class="tac" colspan="2">详情</th>
                                        </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td class="tac"><%#Item.Weight %></td>
                                            <td class="tac"><%#Item.Length %></td>
                                            <td class="tac"><%#Item.Width %></td>
                                            <td class="tac"><%#Item.Height %></td>
                                            <td class="tac"><%#Item.Value %></td>
                                            <td class="tac"><%#Item.Status %></td>
                                            <td class="tac"><%#Item.TrackNumber %></td>
                                            <td class="tac"><%#GetPackagePrice(Item) %></td>
                                            <td class="tac"><a title="明细" class="btn-link" data-container="body" data-toggle="popover" data-placement="bottom" data-content="<%#FormatPackageItems(Item) %>">包裹明细</a></td>
                                            <td class="tac" colspan="2">
                                                <%#GetPacakgeDetail(Item)%>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </ul>
                    </fieldset>
                    <br />
                </ItemTemplate>
            </asp:Repeater>
        </form>
    </div>
</asp:Content>
