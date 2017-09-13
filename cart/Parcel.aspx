﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Parcel.aspx.cs" Inherits="cart_Parcel" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>已发送包裹 | 诚信物流-可靠,快捷,实惠</title>
    <link href="../static/css/pager.css" rel="stylesheet" type="text/css" />  
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
    <div style="margin-top: 15px; background-color: #fff; padding: 15px">
        <form runat="server" method="post" id="placeOrder" style="padding-top: 0px">

            <table class="table table-orders" style="font-size:small;">
                <asp:Repeater runat="server" ItemType="Package" SelectMethod="GetPageApplys">
                    <HeaderTemplate>
                        <tr>
                            <th class="tac">运单号</th>
                            <th class="tac">收件人</th>
                            <th class="tac">收件人地址</th>
                            <th class="tac">收件人电话</th>
                            <th class="tac">重量</th>   
                            <th class="tac">价格</th>                          
                            <th class="tac">面单</th>
                        </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td class="tac"><%#Item.TrackNumber %></td>
                            <td class="tac"><%#Item.Recipient.Name %></td>
                            <td class="tac"><%#Item.Recipient.City + " " + Item.Recipient.Address %></td>
                            <td class="tac"><%#Item.Recipient.PhoneNumber %></td> 
                            <td class="tac"><%#Item.Weight %></td>                            
                            <td class="tac"><%#Item.FinalCost %></td>
                            <td class="tac">
                                <a href="<%#Item.Pdf %>">下载</a>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
            <div class="pager">
                <% for (int i = StartPage; i < GetPageCount(); i++)
                    {
                        Response.Write(
                        string.Format("<a href='/cart/Parcel.aspx?page={0}&startpage={3}' {1} Style=\"vertical-align: middle;\">{2}</a>", i, i == CurrentPage ? "class='selected'" : "", i, StartPage));
                    }%>

                <asp:ImageButton ID="btnNext" ImageUrl="~/static/images/icon/next.jpg" Width="20" Height="20" runat="server" Style="vertical-align: middle;" OnClick="btnNext_Click"/>
            </div>
        </form>
    </div>
</asp:Content>
