<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Reinforce.aspx.cs" Inherits="products_Reinforce" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>包裹加固 | 诚信物流-可靠,快捷,实惠</title>
    <script src="../Scripts/jquery-1.8.0.min.js"></script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="margin-top: 30px">
        <div style="margin-left: auto; margin-right: auto; width: 713px; padding-left: 12px; background: url(/static/img/buzou.png) 1px 0 no-repeat;">
            <a href="/" class="fl buzou" style="padding-left: 20px">快速询价</a>
            <a href="/products/" class="fl buzou" style="padding-left: 20px">产品选择</a>
            <a href="" class="fl buzou active" style="margin: 0 -14px; width: 150px">订单信息</a>
            <a href="#" class="fl buzou" style="padding-left: 45px">在线支付</a>
            <a href="#" class="fl buzou" style="padding-left: 27px">邮件查收</a>
            <div class="cb"></div>
        </div>
    </div>

    <form class="form-inline" id="tree" method="post" runat="server">
        <div class="row" style="background-color: #fff; padding: 20px 15px; margin: 20px 0 30px">
            
            <!-- main --> 
            <div class="col-sm-10 col-xs-12" style="padding-left: 0">
                <div style="border: 0px solid #ccc; padding: 0px; margin: 0px 0px 0px 100px">
                    <img width="550" src="<%:Reinforce1.PictureLink %>" style="cursor: pointer" title="<%:Reinforce1.Type %>" />
                </div>
                <div style="border: 0px solid #ccc; padding: 0px;margin: 0px 0px 0px 100px">                    
                    <input type="radio" name="reinforce" id="reinforce1" checked="checked" value="<%:Reinforce1.Id %>"/><%:Reinforce1.Describe %>    
                </div>
                <div style="border: 0px solid #ccc; padding: 0px; margin: 30px 0px 0px 100px">
                    <img width="550" src="<%:Reinforce2.PictureLink %>" style="cursor: pointer" title="<%:Reinforce2.Type %>" />
                </div>
                <div style="border: 0px solid #ccc; padding: 0px; margin: 0px 0px 0px 100px">
                    <input type="radio" name="reinforce" id="reinforce2" value="<%:Reinforce2.Id %>"/><%:Reinforce2.Describe %> 
                </div>
            </div>

            <!-- right column -->
            <input hidden="hidden" value="<%:GetSendPrice() %>" id="sendPrice" />
            <input hidden="hidden" value="<%:Reinforce1.Price * Order.Recipients.Sum(r => r.Packages.Count) %>" id="reforce1" />
            <input hidden="hidden" value="<%:Reinforce2.Price * Order.Recipients.Sum(r => r.Packages.Count) %>" id="reforce2" />
            <div class="col-sm-2 col-xs-12" style="border: 1px solid #69ADDB">
                <div class="panel" style="box-shadow: none">
                    <div style="margin-top: 10px">
                        <img src="<%:ServiceView.PictureLink %>" style="width: 130px" />
                    </div>

                    <p><strong><%:ServiceView.Name %></strong></p>
                    <p>
                        <img src="<%:ServiceView.DiscribePictureLink %>" width="130" height="78" />
                        <span style="font-size: small;">国际快递时间（不包括清关和旺季延误）: 6-10 天 /&nbsp;自带丢件赔偿: &pound;50磅 /&nbsp;包裹上可贴中文地址</span>
                    </p>

                    <div id="details">
                        <br />
                        <%:ServiceView.PickUpCompany %>:
                        <br />
                        <%:ServiceView.GetPickupPrice(Order).ToString("c", CultureInfo.CreateSpecificCulture("en-GB")) %>
                        <br />                        
                        
                        <asp:Repeater runat="server" ItemType="Package" SelectMethod="GetAllPackages">
                            <ItemTemplate>
                                <br />
                                包裹 <%#Container.ItemIndex + 1 %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%#GetPackagePrice(Item).ToString("c", CultureInfo.CreateSpecificCulture("en-GB")) %><br />
                                -----------------
                            </ItemTemplate>
                        </asp:Repeater>                        
                        <br />
                        <br />
                        <p>加固服务: &nbsp;&nbsp;£<span id="reiforcePrice"></span></p>                                               
                    </div>
                    <br />
                    <p>总额:&nbsp;<span class="sz16 bold clrr1">£</span><span id="total" class="sz16 bold clrr1"></span></p>
                    <div style="margin-bottom: 5px">
                        <label style="font-weight: bold">
                            <input type="checkbox" id="needReforce" class="agreed" checked="checked" style="margin-top: -3px" />
                            需要加固服务
                        </label>
                    </div>
                    <asp:Button runat="server" name="order" ClientIDMode="Static" ID="add2cart" CssClass ="btn btn-primary btn-large" Text="添加到购物车" OnClick="add2cart_Click"/>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">        
        var sendPrice = parseFloat($('#sendPrice')[0].value);
        var reinforcePrice1 = parseFloat($('#reforce1')[0].value);
        var reinforcePrice2 = parseFloat($('#reforce2')[0].value);

        $(document).ready(function () {
            $(window).load(function () {           
                $('#reiforcePrice')[0].innerText = reinforcePrice1.toFixed(2);
                $('#total')[0].innerText = (sendPrice + reinforcePrice1).toFixed(2);
            });

            $('#needReforce').change(function (e) {                

                var reinforcePrice;
                if ($('#needReforce')[0].checked) {
                    $('#reinforce1')[0].disabled = false;
                    $('#reinforce2')[0].disabled = false;                    
                    
                    if ($('#reinforce1')[0].checked)
                    {
                        reinforcePrice = reinforcePrice1;
                    }
                    else
                    {
                        reinforcePrice = reinforcePrice2;
                    }
                    
                }
                else {
                    $('#reinforce1')[0].disabled = true;
                    $('#reinforce2')[0].disabled = true;

                    reinforcePrice = 0.0;
                }

                $('#reiforcePrice')[0].innerText = reinforcePrice.toFixed(2);
                $('#total')[0].innerText = (reinforcePrice + sendPrice).toFixed(2);
            });

            $('#reinforce1').change(function (e) {

                if ($('#reinforce1')[0].checked)
                {                    
                    $('#reiforcePrice')[0].innerText = reinforcePrice1.toFixed(2);
                    $('#total')[0].innerText = (reinforcePrice1 + sendPrice).toFixed(2);
                }                
            });

            $('#reinforce2').change(function (e) {

                if ($('#reinforce2')[0].checked) {
                    $('#reiforcePrice')[0].innerText = reinforcePrice2.toFixed(2);
                    $('#total')[0].innerText = (reinforcePrice2 + sendPrice).toFixed(2);
                }
            });
           
        });
    </script>
</asp:Content>
