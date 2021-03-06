﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Paid.aspx.cs" Inherits="cart_Paid" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>
<script runat="server">

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {

    }
</script>


<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>已付款订单 | 诚信物流-可靠,快捷,实惠</title>
     <link href="../static/css/pager.css" rel="stylesheet" type="text/css" />  
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <ul class="breadcrumb" style="background: none; margin-top: 15px">
    </ul>

    <div class="sz16 bold colorb2" style="margin-top: 20px">
        <h3><span style="font-family:'Microsoft YaHei UI'; font-weight:bold;  font-weight:bold; font-size:large;color:#C34C21;">已支付订单</span></h3>     
    </div>

    <div style="margin-top: 15px; background-color: #fff; padding: 0px">
        <form runat="server" method="post" id="placeOrder" style="padding-top: 0px">
            <fieldset runat="server" id="normalField">
                
                <table class="table table-orders" style="font-size:small;">
                    <asp:Repeater runat="server" ItemType="Order" SelectMethod="GetPageApplys">
                        <HeaderTemplate>
                            <tr>
                                <th class="tac">订单号</th>
                                <th class="tac">下单日期</th>
                                <th class="tac">价格</th>
                                <th class="tac" style="text-align:center;">包裹数</th>
                                <th class="tac">发件人</th>
                                <th>服务</th>
                                <th>状态</th>
                                <th colspan="2"></th>
                            </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr id="<%#Item.Id %>" title="<%#GetOrderTip(Item) %>">
                                <td class="tac"><%#string.Format("{0:d9}", Item.Id) %></td>
                                <td class="tac"><%#Item.OrderTime.Value.ToShortDateString() %></td>
                                <td class="tac"><%#Item.Cost.Value.ToString("c", CultureInfo.CreateSpecificCulture("en-GB")) %></td>
                                <td class="tac" style="text-align:center;"><%#Item.Recipients.Sum(r => r.Packages.Count) %></td>
                                <td class="tac"><%#Item.SenderName %></td>
                                <td class="right"><%#Item.Service.Name %></td>
                                <td><%#GetIcon(Item) %></td>
                                <td class="right">
                                    <asp:LinkButton ID="DownloadLabel" OnClick="DownloadLabel_Click" runat="server" Text="下载面单" data-id="<%#Item.Id %>" Font-Size="small" Visible ="<%#Item.SuccessPaid ?? false %>" />
                                    <asp:LinkButton ID="ReSend" OnClick="ReSend_Click" runat="server" Text="重新发送" ForeColor="green" data-id="<%#Item.Id %>" Font-Size="small" Visible ="<%#!(Item.SuccessPaid ?? false) %>" />
                                </td>
                                <td colspan="2">
                                    <asp:LinkButton ID="NormalDetail" OnClick="NormalDetail_Click" runat="server" Text="详情" data-id="<%#Item.Id %>" Font-Size="small" />                                    
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
                <div class="pager">
                    <% for (int i = StartPage; i < GetPageCount(); i++)
                        {
                            Response.Write(
                            string.Format("<a href='/cart/Paid.aspx?page={0}&startpage={3}' {1} Style=\"vertical-align: middle;\">{2}</a>", i, i == CurrentPage ? "class='selected'" : "", i, StartPage));
                        }%>                    
                   
                    <asp:ImageButton ID="btnNext" ImageUrl="~/static/images/icon/next.jpg" Width="20" Height="20" runat="server" Style="vertical-align: middle;" OnClick="btnNext_Click1" />
                </div>
            </fieldset>
            <br />
           
        </form>
    </div>    
</asp:Content>
