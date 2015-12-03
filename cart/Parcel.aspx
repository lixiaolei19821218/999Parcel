<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Parcel.aspx.cs" Inherits="cart_Parcel" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>已发送包裹 | 诚信物流-可靠,快捷,实惠</title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sz16 bold colorb2" style="margin-top: 20px">
        已发送包裹      
    </div>

    <div style="margin-top: 15px; background-color: #fff; padding: 15px">
        <form runat="server" method="post" id="placeOrder" style="padding-top: 0px">

            <table class="table table-orders">
                <asp:Repeater runat="server" ItemType="Package" SelectMethod="GetPackages">
                    <HeaderTemplate>
                        <tr>
                            <th class="tac">国际追踪号</th>
                            <th class="tac">收件人</th>
                            <th class="tac">详情</th>
                            <th class="tac">重量</th>
                            <th class="tac">服务</th>                           
                            <th colspan="2"></th>
                        </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td class="tac"><%#Item.TrackNumber %></td>
                            <td class="tac"><%#Item.Recipient.Name %></td>
                            <td class="tac"><%#Item.Detail %></td>
                            <td class="tac"><%#Item.Weight %></td>                            
                            <td class="tac"><%#Item.Recipient.Order.Service.Name %></td>
                            <td colspan="2">
                                
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </form>
    </div>
</asp:Content>
