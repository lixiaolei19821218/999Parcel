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
        <span style="font-size:large;font-family:'Microsoft YaHei';">订单详情</span>
        <div style="float: right; font-size: small;">
            <%:Order.Service.Name %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%:GetPickupNumber(Order) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;预约取件时间：<%=GetPickupTime(Order) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;订单号：<%:string.Format("{0:d9}", Session["id"]) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;订单金额：<%:Order.Cost %>
        </div>
    </div>

    <div style="margin-top: 15px; background-color: #fff; padding: 15px; min-height: 600px;">
        <form runat="server" method="post" id="placeOrder" style="padding-top: 0px">
            <fieldset>
                        <legend>发件人：<%:Order.SenderName%><div style="float:right;"><asp:Button ID="ButtonEdit" CssClass="btn btn-info btn-small edit" runat="server" Text="修改订单" style="padding:0px 10px;" OnClick="ButtonEdit_Click"/>&nbsp;&nbsp<asp:Button ID="ButtonReSend" CssClass="btn btn-danger btn-small del" runat="server" Text="重新发送" style="padding:0px 10px;" OnClick="ButtonReSend_Click"/></div></legend>
                        <ul>
                            <li>城市：<%:Order.SenderCity %></li>
                            <li>邮编：<%:Order.SenderZipCode %></li>                            
                            <li>地址：<%:Order.SenderAddress1 %> <%:Order.SenderAddress2 %> <%:Order.SenderAddress3 %></li>
                            <li>电话：<%:Order.SenderPhone %></li>                                                          
                        </ul>
                    </fieldset>
            <asp:Repeater runat="server" ItemType="Recipient" SelectMethod="GetRecipients">
                <ItemTemplate>
                    <fieldset>
                        <legend>收件人：<%#Item.Name %><%#GetStatus(Item)%><asp:Button ID="ButtonCancelReciver" CssClass="btn btn-danger btn-small del" runat="server" Text="取消运单" data-id="<%#Item.Id %>" OnClick="ButtonCancelReciver_Click" style="<%#GetCancelReceiverStyle(Item)%>" ToolTip="取消此收件人所有运单"/></legend>

                        <ul>
                            <li>城市：<%#Item.Province + " " + Item.City %></li>
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
                                            <th colspan="1"></th>                                    
                                        </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td class="tac"><%#Item.Weight %></td>
                                            <td class="left"><%#Item.Length %></td>
                                            <td class="tac"><%#Item.Width %></td>
                                            <td class="tac"><%#Item.Height %></td>
                                            <td class="tac"><%#Item.FinalCost %></td>
                                            <td class="tac"><%#Item.Status %></td>
                                            <td class="tac"><%#Item.TrackNumber %></td>                                            
                                            <td colspan="2">
                                                <%#GetPacakgeDetail(Item)%>
                                            </td>       
                                            <td colspan="1">
                                               <asp:Button ID="ButtonCancel" CssClass="btn btn-danger btn-small del" runat="server" Text="取消" data-id="<%#Item.Id %>" OnClick="ButtonCancel_Click" style="<%#GetCancelParcelStyle(Item)%>"/>
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
                <label style="font-family: 'Microsoft YaHei UI';">费用补交</label><input type="number" id="sub" runat="server" style="width: 50px; margin-left: 5px; margin-right: 5px;" min="0" value="0" /><asp:Button runat="server" CssClass="btn btn-info" Style="margin-bottom: 3px; line-height: 1" Text="确定" ID="ButtonSub" OnClick="ButtonSub_Click" />
                <label style="margin-left: 20px; font-family: 'Microsoft YaHei UI';">运费赔付</label><input id="add" runat="server" type="number" style="width: 50px; margin-left: 5px; margin-right: 5px;" min="0" value="0" /><asp:Button runat="server" CssClass="btn btn-info" Style="margin-bottom: 3px; line-height: 1" Text="确定" ID="ButtonAdd" OnClick="ButtonAdd_Click" />
                <asp:Label runat="server" ID="message" ForeColor="Green" />
            </div>
            <hr id="hrConfirm" runat="server" visible="false"/>
            <div class="mg1">
                <asp:Button runat="server" CssClass="btn btn-info" Style="margin-bottom: 3px; line-height: 1;" Text="确认已取件" ID="ButtonPickedUp" OnClick="ButtonPickedUp_Click" />               
                <asp:Button runat="server" CssClass="btn btn-info" Style="margin-bottom: 3px; line-height: 1" Text="确认已人工发送成功" ID="ButtonSuccessPaid" OnClick="ButtonSuccessPaid_Click" />
                <asp:Label runat="server" ID="message2" ForeColor="Green" />
                </div>
            <hr />
            <div class="mg1">
                <a href="/admin/checkorder.aspx">返回订单列表</a>
            </div>
        </form>
    </div>
   
</asp:Content>
