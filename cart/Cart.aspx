<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="cart_Cart" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>购物车 | 诚信物流-可靠,快捷,实惠</title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <ul class="breadcrumb" style="background: none; margin-top: 15px">
    </ul>

    <div style="margin-top: 30px">
        <div style="margin-left: auto; margin-right: auto; width: 713px; padding-left: 12px; background: url(/static/img/buzou.png) 1px 0 no-repeat;">
            <a href="/" class="fl buzou" style="padding-left: 25px">快速询价</a>
            <a href="/products/" class="fl buzou" style="padding-left: 20px">产品选择</a>
            <a href="#" class="fl buzou" style="padding-left: 30px">包裹信息</a>
            <a href="" class="fl buzou active" style="padding-left: 5px; width: 150px; margin: 0 -16px">在线支付</a>
            <a href="#" class="fl buzou" style="padding-left: 30px">邮件查收</a>
            <div class="cb"></div>
        </div>
    </div>

    <div class="sz16 bold colorb2" style="margin-top: 20px">
        请确认订单
        <div style="float: right; margin-left: 10px"><a href="../accounts/UserCentre/Recharge.aspx" class="btn btn-danger" style="line-height: 1; padding: 5px 15px">立即充值</a></div>
        <div style="float: right">帐户余额:<strong style="color: #f00">£<%:GetAmount() %></strong></div>
    </div>

    <div style="margin-top: 15px; background-color: #fff; padding: 15px">



        <p class="prompt"></p>




        

        <form runat="server" method="post" id="placeOrder" style="padding-top: 0px">           
            <fieldset runat="server" id="normalField">
                <legend>直邮订单</legend>
                <table class="table table-orders">
                    <asp:Repeater runat="server" ItemType="Order" SelectMethod="GetNoneSheffieldOrders">
                        <HeaderTemplate>
                            <tr>
                                <th class="tac">订单号</th>
                                <th class="left">下单日期</th>
                                <th class="tac">价格</th>
                                <th class="tac">包裹数</th>
                                <th class="tac">发件人</th>
                                <th>服务</th>
                                <th colspan="2"></th>
                            </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <input type='hidden' name='orders' />
                            <tr id="<%#Item.Id %>" title="<%#GetOrderTip(Item) %>">
                                <td class="tac"><%#string.Format("{0:d9}", Item.Id) %></td>
                                <td class="left"><%#Item.OrderTime.Value.ToShortDateString() %></td>
                                <td class="tac"><%#Item.Cost.Value.ToString("c", CultureInfo.CreateSpecificCulture("en-GB")) %></td>
                                <td class="tac"><%#Item.Recipients.Sum(r => r.Packages.Count) %></td>
                                <td class="tac"><%#Item.SenderName %></td>
                                <td class="right"><%#Item.Service.Name %></td>
                                <td colspan="2">
                                    <asp:Button ID="ButtonEdit" class="btn btn-info btn-small edit" runat="server" Text="修改" data-id="<%#Item.Id %>" OnClick="ButtonEdit_Click" />
                                    <asp:Button ID="ButtonDel" class="btn btn-danger btn-small del" runat="server" Text="删除" data-id="<%#Item.Id %>" OnClick="ButtonDel_Click" />
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
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
                            <tr id="<%#Item.Id %>"">
                                <td class="tac"><%#string.Format("{0:d9}", Item.Id) %></td>
                                <td class="left"><%#Item.Orders.First().OrderTime.Value.ToShortDateString() %></td>
                                <td class="tac"><%#Item.Orders.Sum(o => o.Cost) %></td>
                                <td class="tac"><%#Item.Orders.Sum(o => o.Recipients.First().Packages.Count)%></td>
                                <td class="tac"><%#Item.Orders.First().SenderName %></td>
                                <td class="right">谢菲尔德地区服务</td>
                                <td colspan="2">
                                    <asp:Button ID="ButtonSheffieldEdit" class="btn btn-info btn-small edit" runat="server" Text="修改" data-id="<%#Item.Id %>" OnClick="ButtonSheffieldEdit_Click" />
                                    <asp:Button ID="ButtonSheffieldDel" class="btn btn-danger btn-small del" runat="server" Text="删除" data-id="<%#Item.Id %>" OnClick="ButtonSheffieldDel_Click" />
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>

            </fieldset>
            <div>
                
                <div style="float: right">总金额: <strong class="total-price" style="color: #f00"><%:GetTotalPrice().ToString("c", CultureInfo.CreateSpecificCulture("en-GB")) %></strong></div>
            </div>

            <div style="margin-top: 50px;">
                
                <legend></legend>
                <div style="padding: 0px; margin: 0px">

                   <a href="/" class="btn btn-info" style="line-height: 1">继续下单</a>

                    <asp:Button ID="pay" runat="server" CssClass="btn btn-info" Text="支付定单" style="line-height: 1" OnClick="pay_Click" />
                    

                    <div style="clear: both"></div>
                </div>
            </div>


        </form>



    </div>

    <!-- hidden forms -->
    <div id="dialog-confirm" style="display: none"></div>
    <input type="hidden" name="action" id="action" />


    <div id="expired" style="display: none"></div>



    <div id="insufficient" style="display: none"></div>





</asp:Content>
