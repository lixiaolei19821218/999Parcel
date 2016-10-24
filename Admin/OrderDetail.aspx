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
            <fieldset>
                        <legend>发件人：<%:Order.SenderName%></legend>
                        <ul>
                            <li>城市：<%:Order.SenderCity %></li>
                            <li>邮编：<%:Order.SenderZipCode %></li>                            
                            <li>地址：<%:Order.SenderAddress1 %> <%:Order.SenderAddress2 %> <%:Order.SenderAddress3 %></li>
                            <li>电话：<%:Order.SenderPhone %></li>
                            <li>邮箱：<%:Order.SenderEmail %></li>
                        </ul>
                    </fieldset>
            <asp:Repeater runat="server" ItemType="Recipient" SelectMethod="GetRecipients">
                <ItemTemplate>
                    <fieldset>
                        <legend>收件人：<%#Item.Name %><%#GetStatus(Item)%></legend>

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
                                            
                                            <td colspan="2">
                                                <%#GetPacakgeDetail(Item)%>
                                            </td>                                           
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </ul>
                    </fieldset>
                </ItemTemplate>
            </asp:Repeater>
             <hr />
        <div class="mg1">
            <label style="font-family:'Microsoft YaHei UI';">费用补交</label><input type="number" id="sub" runat="server" style="width:50px; margin-left:5px; margin-right:5px;" min="0" value="0" /><asp:Button runat="server" cssclass="btn btn-info" style="margin-bottom: 3px; line-height: 1" text="确定" ID="ButtonSub" OnClick="ButtonSub_Click" />
            <label style="margin-left:20px; font-family:'Microsoft YaHei UI';">运费赔付</label><input id="add" runat="server" type="number" style="width:50px; margin-left:5px; margin-right:5px;" min="0" value="0" /><asp:Button runat="server" cssclass="btn btn-info" style="margin-bottom: 3px; line-height: 1" text="确定" ID="ButtonAdd" OnClick="ButtonAdd_Click" />
        <asp:Label runat="server" ID="message"  ForeColor="Green"/>
        </div>
        </form>
    </div>
   
</asp:Content>
