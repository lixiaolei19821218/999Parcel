<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderDetail.aspx.cs" Inherits="cart_OrderDetail" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>已发送包裹 | 诚信物流-可靠,快捷,实惠</title>
    <link href="../static/bootstrap3/css/bootstrap.min.css" rel="stylesheet">
    <script src="../static/bootstrap3/js/jquery-1.11.1.min.js"></script>
    <script src="../static/bootstrap3/js/bootstrap.min.js"></script>
    <script>$(function () {
    $("[data-toggle='popover']").popover();
});
    </script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sz16 bold colorb2" style="margin-top: 20px">
        订单详情
        <div style="float: right; font-size: smaller">
            <%:Order.Service.Name %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;取件时间：<%:GetPickupTime(Order) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;订单号：<%:string.Format("{0:d9}", Session["id"]) %>
        </div>
    </div>

    <div style="margin-top: 15px; background-color: #fff; padding: 15px; min-height: 600px;">
        <form runat="server" method="post" id="placeOrder" style="padding-top: 0px">
            <asp:Repeater runat="server" ItemType="Recipient" SelectMethod="GetRecipients">
                <ItemTemplate>
                    <fieldset>
                        <legend>收件人：<%#Item.Name %><%#(Item.SuccessPaid ?? false) ? "<div style=\"float:right;font-size:medium;color:green;\">发送成功</div>" : "<div style=\"float:right;font-size:medium;color:red;\">发送失败</div>"%></legend>
                        
                        <ul>
                            <li>城市：<%#Item.City %></li>
                            <li>地址：<%#Item.Address %></li>
                            <li>手机：<%#Item.PhoneNumber %></li>
                            <li>邮编：<%#Item.ZipCode %></li>
                            <table class="table table-orders" style="margin-top: 10px">
                                <asp:Repeater runat="server" ItemType="Package" DataSource="<%#Item.Packages %>">
                                    <HeaderTemplate>
                                        <tr>
                                            <th class="tac">重量</th>
                                            <th class="left">长度</th>
                                            <th class="tac">宽度</th>
                                            <th class="tac">高度</th>
                                            <th class="tac">总额</th>
                                            <th class="tac">状态</th>
                                            <th class="tac">跟踪号</th>
                                            <th class="tac">运费</th>
                                            <th colspan="2">详情</th>                                            
                                        </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td class="tac"><%#Item.Weight %></td>
                                            <td class="left"><%#Item.Length %></td>
                                            <td class="tac"><%#Item.Width %></td>
                                            <td class="tac"><%#Item.Height %></td>
                                            <td class="tac"><%#Item.Value %></td>
                                            <td class="tac"><%#Item.Status %></td>
                                            <td class="tac"><%#Item.TrackNumber %></td>
                                            <td class="tac">130</td>
                                            <td colspan="2">
                                                <%#GetPacakgeDetail(Item)%>
                                            </td>                                            
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </ul>
                    </fieldset>
                    <br />
                    <asp:Button ID="ButtonEdit" CssClass="btn btn-info btn-small edit" runat="server" Text="修改" data-id="<%#Item.Id %>" style="padding:0px 10px;" />
                                    
                    <asp:Button ID="ButtonDel" CssClass="btn btn-danger btn-small del" runat="server" Text="删除" data-id="<%#Item.Id %>"  style="padding:0px 10px;"/>
                </ItemTemplate>
            </asp:Repeater>
        </form>
    </div>
</asp:Content>
