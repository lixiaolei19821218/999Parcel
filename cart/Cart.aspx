<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="cart_Cart" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>购物车 | 诚信物流-可靠,快捷,实惠</title>
    <style type="text/css">
       
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("input[name*='ButtonPayOne']").click(function (e) {              
                e.currentTarget.value = 'Paying..';              
            })
            $("input[name*='payAll']").click(function (e) {
                e.currentTarget.value = 'Paying..';
            })
        });
    </script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <ul class="breadcrumb" style="background: none; margin-top: 15px">
    </ul>

    <asp:Label ID="lbmessage" runat="server" Text="" Forecolor="Red"></asp:Label>
    
    <div class="sz16 bold colorb2" style="margin-top: 0px;font-family:'Microsoft YaHei UI'; font-weight:bold;  font-weight:bold; font-size:large;color:#C34C21;padding-top:30px;"">
        请确认订单
        <div style="float: right; margin-left: 10px"><a href="../accounts/UserCentre/Recharge.aspx" class="btn btn-danger" style="line-height: 1; padding: 5px 15px">立即充值</a></div>
        <div style="float: right">帐户余额:<strong style="color: #f00">£<%:GetAmount() %></strong></div>
    </div>

    <div style="margin-top: 15px; background-color: #fff; padding: 15px;">



        <p class="prompt"></p>




        

        <form runat="server" method="post" id="placeOrder" style="padding-top:0px;">           
            <fieldset runat="server" id="normalField" style="min-height:300px;">
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
                                <th class="right" colspan="3"></th>
                            </tr>
                        </HeaderTemplate>                        
                        <ItemTemplate>
                            <input type='hidden' name='orders' />                                            
                            <tr id="<%#Item.Id %>" title="<%#GetOrderTip(Item) %>">
                                <td class="tac" style="vertical-align:middle;"><%#string.Format("{0:d9}", Item.Id) %></td>
                                <td class="left" style="vertical-align:middle;"><%#Item.OrderTime.HasValue ? Item.OrderTime.Value.ToShortDateString() : "" %></td>
                                <td class="tac" style="vertical-align:middle;"><%#Item.Cost.Value.ToString("c", CultureInfo.CreateSpecificCulture("en-GB")) %></td>
                                <td class="tac" style="vertical-align:middle;"><%#Item.Recipients.Sum(r => r.Packages.Count) %></td>
                                <td class="tac" style="vertical-align:middle;"><%#Item.SenderName %></td>
                                <td class="right" style="vertical-align:middle;"><%#Item.Service.Name %></td>
                                <td class="right" colspan="3">
                                    <asp:Button ID="ButtonEdit" CssClass="btn btn-info btn-small edit" runat="server" Text="修改" data-id="<%#Item.Id %>" OnClick="ButtonEdit_Click" style="padding:0px 10px;" />
                                    <asp:Button ID="ButtonDel" CssClass="btn btn-danger btn-small del" runat="server" Text="删除" data-id="<%#Item.Id %>" OnClick="ButtonDel_Click"  style="padding:0px 10px;"/>
                                    <asp:Button ID="ButtonPayOne" CssClass="btn btn-danger btn-small del payone" runat="server" Text="支付" data-id="<%#Item.Id %>" OnClick="ButtonPayOne_Click"  style="padding:0px 10px;width:70px;"/>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
            </fieldset>
            <br />
            <!--
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

            </fieldset>-->
            
            <div>
                <asp:RadioButton runat="server" ID="rbBalance" Text="余额支付" Checked="true" GroupName="PayMethod" OnCheckedChanged="rbBalance_CheckedChanged" AutoPostBack="false" />
                    <asp:RadioButton runat="server" ID="rbWorldPay" Text="World Pay支付" GroupName="PayMethod" OnCheckedChanged="rbWorldPay_CheckedChanged" AutoPostBack="false" />
                <div style="float: right">总金额: <strong class="total-price" style="color: #f00"><%:GetTotalPrice().ToString("c", CultureInfo.CreateSpecificCulture("en-GB")) %></strong></div>
            </div>

            <div style="margin-top: 50px;">
                
                <legend style="font-size: small;"><%:GetTips() %></legend>
                <div style="padding: 0px; margin: 0px">

                   <a href="/" class="btn btn-info" style="line-height: 1;width:120px;">继续下单</a>

                    <asp:Button ID="payAll" runat="server" CssClass="btn btn-info" Text="支付所有定单" style="line-height: 1;width:120px;" OnClick="pay_Click" />
                    
                    
                    <table border="0" style="float: right;">
                        <tbody>
                            <tr>
                                <td style="width:70px;">
                                    <input name="op-DPChoose-ECMC^SSL" type="image" src="/static/img/logos/99b8b93b12bbdb95c94a3ded6239461.png" alt="Mastercard" />                                    
                                </td>
                                <td style="width:70px;">
                                    <input name="op-DPChoose-VISA^SSL" type="image" src="/static/img/logos/c514e1e08db201b45993b344e9f312e.png" alt="Visa" />                               
                                </td>
                                <td style="width:70px;">
                                    <input name="op-DPChoose-Maestro^SSL" type="image" src="/static/img/logos/78b6bdb195e7fc394b09c80f2b0a6e4.png" alt="Maestro" />                                    
                                </td>
                                <td style="width:70px;">
                                    <input name="op-DPChoose-JCB^SSL" type="image" src="/static/img/logos/8d0fb151dc66e94b4969fe63748a473.png" alt="JCB" />                                    
                                </td>
                                <td style="width:70px;">
                                    <input name="op-DPChoose-WP^SSL" type="image" src="/static/img/logos/d9c9a010ab363d78b82a3aff5837f86.png" alt="worldpay" />                                    
                                </td>
                               
                            </tr>
                        </tbody>
                    </table>
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
