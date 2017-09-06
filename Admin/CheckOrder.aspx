<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CheckOrder.aspx.cs" Inherits="Admin_CheckOrder" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>订单管理</title>
    <link href="../static/css/pager.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <ul class="breadcrumb" style="background: none; margin-top: 15px">
    </ul>
    <form runat="server" method="post" id="placeOrder" style="padding-top: 0px;">
        <div class="mg1">            
            <div class="rds2" style="background-color: #fff; padding-left: 0px; padding-right: 20px">
                <input type="text" style="margin: 10px 0; width: 30%; height: 30px" placeholder="订单号/用户名" id="content" name="content" />
                <asp:Button runat="server" CssClass="btn btn-info" Style="margin-bottom: 3px; line-height: 1" Text="查询 &gt;" ID="FindOrder" OnClick="FindOrder_Click" />
                <a href="/admin/CheckApply.aspx" style="float: right;margin: 15px 0;">返回管理页</a>
            </div>           
        </div>
       
        <div style="margin-top: 15px; background-color: #fff; padding: 0px;">
            <fieldset runat="server" id="normalField">
                <legend>已付款订单</legend>
                <table class="table table-orders" style="font-size:small;">
                    <asp:Repeater ID="rptOrder" runat="server" ItemType="Order" SelectMethod="GetPageApplys">
                        <HeaderTemplate>
                            <tr>
                                <th class="tac">订单号</th>
                                <th class="tac">邮编</th>
                                <th class="tac">地址</th>
                                <th class="tac">发件人</th>
                                <th class="tac">电话</th>
                                <th class="tac">取件时间</th>
                                <th class="tac">包裹数</th>                                
                                <th>状态</th>
                                <th class="tac">取件号</th>
                                <th colspan="1">详情</th>
                                <th class="tac">确认收件</th>
                            </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr id="<%#Item.Id %>" title="<%#GetOrderTip(Item) %>">
                                <td class="tac"><%#string.Format("{0:d9}", Item.Id) %></td>
                                <td class="tac"><%#Item.SenderZipCode %></td>
                                <td class="tac"><%#Item.SenderAddress1 + " " + Item.SenderAddress2 + " " + Item.SenderAddress3 + " " + Item.SenderCity %></td>                                
                                <td class="tac"><%#Item.SenderName %></td>
                                <td class="tac"><%#Item.SenderPhone%></td>
                                <td class="tac"><%#GetPickupTime(Item)%></td>
                                <td class="tac" style="text-align:center;"><%#Item.Recipients.Sum(r => r.Packages.Count) %></td>
                                <td><%#GetStatus(Item) %></td>
                                <td class="tac"><%#Item.UKMConsignmentNumber%></td>
                                <td colspan="1">
                                    <asp:LinkButton ID="NormalDetail" OnClick="NormalDetail_Click" runat="server" Text="详情" data-id="<%#Item.Id %>" Font-Size="Small" />
                                </td>
                                 <td class="tac" style="text-align:center;">
                                     <asp:CheckBox ID="chxPickup" runat="server" data-id="<%#Item.Id %>"/>
                                 </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
                <div class="pager">
                    <% for (int i = 1; i <= MaxPage; i++)
                        {
                            Response.Write(
                            string.Format("<a style=\"float:left;\" href='/admin/CheckOrder.aspx?page={0}' {1}>{2}</a>", i, i == CurrentPage ? "class='selected'" : "", i));
                        }%>
                    
                    <asp:Button ID="ButtonConfirm" runat="server" CssClass="btn btn-danger" Style="margin-bottom: 3px; line-height: 1; float: right;" Text="确认取件" OnClick="ButtonConfirm_Click" />
                </div>                
            </fieldset>
            <br />           
        </div>
    </form>
</asp:Content>
