<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CheckOrder.aspx.cs" Inherits="Admin_CheckOrder" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>订单管理</title>
    <link href="../static/css/pager.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <ul class="breadcrumb" style="background: none; margin-top: 15px">
    </ul>
    <form runat="server" method="post" id="placeOrder" style="padding-top: 0px">
        <div class="mg1">
            <div class="bg1 rds1 clrw1 sz16" style="height: 38px; background-position: 0 0; background-repeat: repeat-x; padding: 10px 20px">
                订单查询
            </div>
            <div class="rds2" style="background-color: #fff; padding-left: 20px; padding-right: 20px">
                <input type="text" style="margin: 10px 0; width: 30%; height: 30px" placeholder="订单号/用户名" id="content" name="content">
                <asp:Button runat="server" cssclass="btn btn-info" style="margin-bottom: 3px; line-height: 1" text="查询 &gt;" ID="FindOrder" OnClick="FindOrder_Click" />
            </div>
        </div>

        <div class="sz16 bold colorb2" style="margin-top: 30px">
            问题订单      
        </div>
        <div style="margin-top: 15px; background-color: #fff; padding: 15px">
            <fieldset runat="server" id="normalField">
                <legend>直邮订单</legend>
                <table class="table table-orders">
                    <asp:Repeater runat="server" ItemType="Order" SelectMethod="GetPageApplys">
                        <HeaderTemplate>
                            <tr>
                                <th class="tac">订单号</th>
                                <th class="left">下单日期</th>
                                <th class="tac">价格</th>
                                <th class="tac">包裹数</th>
                                <th class="tac">发件人</th>
                                <th>服务</th>
                                <th>状态</th>
                                <th colspan="2"></th>
                            </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr id="<%#Item.Id %>" title="<%#GetOrderTip(Item) %>">
                                <td class="tac"><%#string.Format("{0:d9}", Item.Id) %></td>
                                <td class="left"><%#Item.OrderTime.HasValue ? Item.OrderTime.Value.ToShortDateString() : string.Empty %></td>
                                <td class="tac"><%#Item.Cost.Value.ToString("c", CultureInfo.CreateSpecificCulture("en-GB")) %></td>
                                <td class="tac"><%#Item.Recipients.Sum(r => r.Packages.Count) %></td>
                                <td class="tac"><%#Item.SenderName %></td>
                                <td class="right"><%#Item.Service.Name %></td>
                                <td><%#(Item.SuccessPaid.HasValue && Item.SuccessPaid.Value) ? "<img src=\"../static/images/icon/onCorrect.gif\" title=\"发送成功\">" : "<img src=\"../static/images/icon/onFocus.gif\" title=\"有发送失败的包裹\">" %></td>
                                <td colspan="2">
                                    <asp:LinkButton ID="NormalDetail" OnClick="NormalDetail_Click" runat="server" Text="详情" data-id="<%#Item.Id %>" Font-Size="Medium" />
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
                <div class="pager">
                    <% for (int i = 1; i <= MaxPage; i++)
                       {
                           Response.Write(
                           string.Format("<a href='/admin/CheckOrder.aspx?page={0}' {1}>{2}</a>", i, i == CurrentPage ? "class='selected'" : "", i));
                       }%>
                </div>
            </fieldset>
            <br />
            <fieldset runat="server" id="sheffieldField">
                <legend>谢菲尔德地区订单</legend>
                <table class="table table-orders">
                    <asp:Repeater runat="server" ItemType="SheffieldOrder" SelectMethod="GetSheffieldOrders">
                        <HeaderTemplate>
                            <tr>
                                <th class="tac">订单号</th>
                                <th class="left">下单日期</th>
                                <th class="tac">价格</th>
                                <th class="tac">包裹数量</th>
                                <th class="tac">发件人</th>
                                <th>服务</th>
                                <th colspan="2"></th>
                            </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <input type='hidden' name='orders' />
                            <tr id="<%#Item.Id %>">
                                <td class="tac"><%#string.Format("{0:d9}", Item.Id) %></td>
                                <td class="left"><%#Item.Orders.First().OrderTime.HasValue ? Item.Orders.First().OrderTime.Value.ToShortDateString() : string.Empty %></td>
                                <td class="tac"><%#Item.Orders.Sum(o => o.Cost) %></td>
                                <td class="tac"><%#Item.Orders.Sum(o => o.Recipients.First().Packages.Count)%></td>
                                <td class="tac"><%#Item.Orders.First().SenderName %></td>
                                <td class="right">谢菲尔德地区服务</td>
                                <td colspan="2">
                                    <asp:LinkButton ID="ButtonSheffieldEdit" runat="server" Text="详情" data-id="<%#Item.Id %>" ToolTip="<%#Item.Id %>" />
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
            </fieldset>
        </div>
    </form>
</asp:Content>
