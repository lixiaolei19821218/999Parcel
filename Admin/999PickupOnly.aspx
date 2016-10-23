<%@ Page Language="C#" AutoEventWireup="true" CodeFile="999PickupOnly.aspx.cs" Inherits="Admin_CheckOrder" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>订单管理(诚信物流取件)</title>
    <link href="../static/css/pager.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <ul class="breadcrumb" style="background: none; margin-top: 15px">
    </ul>
    <form runat="server" method="post" id="placeOrder" style="padding-top: 0px">
        <div class="mg1">
            
            <div class="rds2" style="background-color: #fff; padding-left: 0px; padding-right: 20px">
                <input type="text" style="margin: 10px 0; width: 30%; height: 30px" placeholder="订单号/用户名" id="content" name="content"/>
                <asp:Button runat="server" cssclass="btn btn-info" style="margin-bottom: 3px; line-height: 1" text="查询 &gt;" ID="FindOrder" OnClick="FindOrder_Click" />
            </div>
        </div>

       
        <div style="margin-top: 15px; background-color: #fff; padding: 0px">
            <fieldset runat="server" id="normalField">
                <legend>已付款订单</legend>
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
                                <td><%#GetStatus(Item) %></td>
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
           
        </div>
    </form>
</asp:Content>
