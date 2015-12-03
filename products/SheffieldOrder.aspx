<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SheffieldOrder.aspx.cs" Inherits="products_SheffiledOrder" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>谢菲尔德地区服务订单信息 | 诚信物流-可靠,快捷,实惠</title>

    <%: System.Web.Optimization.Scripts.Render("~/bundle/jquery") %>
    <script type="text/javascript" src="../Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="../Scripts/jQuery.Hz2Py-min.js"></script>

    <link rel="stylesheet" href="/static/jquery-ui-1.11/jquery-ui.min.css">
    <link rel="stylesheet" href="/static/font-awesome/css/font-awesome.min.css">

    <link href="/static/css/datetimepicker.css" type="text/css" media="all" rel="stylesheet" />
    <script type="text/javascript" src="/static/js/bootstrap-datetimepicker.js"></script> 

    <script type="text/javascript">

        $(document).ready(function () {
            $('.agreed').click(function () {
                if ($(this).prop('checked')) {
                    $('.agreed').not($(this)).prop('checked', 'checked');
                    $('#add2cart').removeAttr('disabled');
                }
                else {
                    $('.agreed').not($(this)).removeAttr('checked');
                    $('#add2cart').prop('disabled', 'disabled');
                }
            });
        })
    </script>

    <style type="text/css">
        label {
            margin-bottom: 5px;
        }

        .add-on {
            padding-left: 5px;
        }

        #id_pickup_time_0 {
            width: 75px;
            font-size: 12px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form class="form-inline" id="tree" method="post" runat="server">
        <div class="row" style="background-color: #fff; padding: 20px 15px; margin: 20px 0 30px">
            <!-- main -->
            <div class="col-sm-10 col-xs-12" style="padding-left: 0">
                <!-- alert messages -->
                <div>
                    <div class="alert alert-success">
                        <a class="close" href="#" onclick="$(this).parent().fadeOut('fast'); return false;">×</a>
                        <ul>
                            <li>收件人信息可以直接中文输入, 拼音地址同步转换呈现。 输入的中文地址会显示在运单条形码文件中， 最大化节省您的时间。</li>
                            <li>中国的手机必须为11位数字, 邮编必须为6位数字。</li>
                            <li>一次下单可添加发往多个收件人的包裹，所产生的文档一键打印即可。</li>
                        </ul>
                    </div>
                </div>

                <ol id="root" style="padding-left: 0">
                    <li style="list-style: none">

                        <!-- sender address -->
                        <div>
                            <div class="bg1 rds1 clrw1" style="height: 38px; background-position: 0 0; background-repeat: repeat-x; padding: 10px 20px">
                                发件人地址（英国）
                            </div>

                            <div class="rds2" style="border: 1px solid #ddd; background-color: #F2F8FC; padding: 5px 1px">
                                <div style="float: left; margin: 5px" class="control-group ">
                                    <label for="id_billing_detail_name">姓名</label>
                                    <input class="input-medium" id="id_billing_detail_name" maxlength="25" name="billing_detail_name" style="width: 115px" type="text" value="<%:SheffieldOrder.Orders.ElementAt(0).SenderName %>" required="required" />


                                </div>
                                <div style="float: left; margin: 5px" class="control-group ">
                                    <label for="id_billing_detail_street">地址</label>
                                    <input class="input-xxlarge" id="id_billing_detail_street" maxlength="24" name="billing_detail_street" style="width: 180px" type="text" value="<%:SheffieldOrder.Orders.ElementAt(0).SenderAddress1 %>" required="required" />




                                </div>
                                <div style="float: left; margin: 5px" class="control-group ">
                                    <input class="input-medium" id="id_billing_detail_street2" maxlength="24" name="billing_detail_street2" style="width: 180px" type="text" value="<%:SheffieldOrder.Orders.ElementAt(0).SenderAddress2 %>" required="required" />




                                </div>
                                <div style="float: left; margin: 5px" class="control-group ">
                                    <input class="input-medium" id="id_billing_detail_street3" maxlength="24" name="billing_detail_street3" style="width: 173px" type="text" value="<%:SheffieldOrder.Orders.ElementAt(0).SenderAddress3 %>" required="required" />




                                </div>
                                <div style="clear: both"></div>

                                <div style="float: left; margin: 5px" class="control-group ">
                                    <label for="id_billing_detail_city">城市</label>
                                    <input class="input-medium" id="id_billing_detail_city" maxlength="24" name="billing_detail_city" style="width: 115px" type="text" value="<%:SheffieldOrder.Orders.ElementAt(0).SenderCity %>" required="required" />




                                </div>
                                <div style="float: left; margin: 5px" class="control-group ">
                                    <label for="id_billing_detail_phone">电话</label>
                                    <input class="input-medium" id="id_billing_detail_phone" maxlength="15" name="billing_detail_phone" style="width: 180px" type="text" value="<%:SheffieldOrder.Orders.ElementAt(0).SenderPhone %>" required="required" />




                                </div>
                                <div style="float: left; margin: 5px" class="control-group ">
                                    <label for="id_billing_detail_postcode">邮编</label>
                                    <input class="input-medium" id="id_billing_detail_postcode" maxlength="8" name="billing_detail_postcode" style="width: 100px" type="text" value="<%:SheffieldOrder.Orders.ElementAt(0).SenderZipCode %>" required="required" />




                                </div>

                                <div style="float: left; margin: 5px">
                                    <button type="button" onclick="cp_obj_1.doLookup()">查找地址</button>
                                </div>

                                <div id="crafty_postcode_result_display_1" style="float: left; margin: 5px"></div>

                                <div style="clear: both; display: none">
                                    <div style="float: left; margin: 5px" class="control-group ">
                                        <label for="id_billing_detail_email">Email</label>
                                        <input class="input-medium" id="id_billing_detail_email" maxlength="50" name="billing_detail_email" style="width: 180px" type="text" value=""/>




                                    </div>
                                </div>

                                <div style="clear: both"></div>
                            </div>
                        </div>

                        <div style="margin-top: 10px; margin-bottom: 10px">
                            <div class="clrw1 rds1" style="background-color: #7F7983; padding: 5px 20px">
                                取件安排
                            </div>
                            <div class="rds2" style="padding: 5px 2px; border: 1px solid #ddd; background-color: #F2F8FC">
                                <div style="float: left; margin: 5px; font-weight: bold; margin-right: 10px">取件公司 <span id="pickUpCompany" style="background-color: #e1e1e1; padding: 2px 4px; font-size: 12px; font-weight: normal">999parcel</span></div>

                                <div style="float: left; margin: 5px" class="control-group ">
                                    <label for="id_pickup_time_0">日期</label>
                                    <div class="input-append date form_datetime">
                                        <input class="input-medium" foo_bar="prevent_readonly" id="id_pickup_time_0" name="pickup_time_0" type="text" value="<%:SheffieldOrder.Orders.First().PickupTime.HasValue ? SheffieldOrder.Orders.First().PickupTime.Value.ToShortDateString() : null %>" required="required" />
                                        <span id="sp" class="add-on"><i class="icon-th"></i></span>
                                    </div>
                                </div>
                                <div style="float: left; margin: 5px; font-weight: bold; margin-left: 10px; margin-right: 10px">
                                    时间

                    
                        <span style="background-color: #BFBFBF; padding: 2px 4px; font-size: 12px; font-weight: normal">9:00-18:00</span>


                                </div>

                                <div style="float: left; margin: 5px" class="control-group ">
                                    <label for="id_additional_instructions">备注</label>
                                    <input class="input-xxlarge" id="id_additional_instructions" maxlength="50" name="additional_instructions" style="width: 290px" type="text" />




                                </div>
                                <div style="clear: both"></div>
                            </div>
                        </div>

                        <div>
                            <div class="bg1 rds1 clrw1" style="height: 38px; background-position: 0 0; background-repeat: repeat-x; padding: 10px 20px">
                                收件人地址（中国）
                            </div>

                            <div class="rds2" style="border: 1px solid #ddd; background-color: #F2F8FC; padding: 5px 1px">
                                <div style="float: left; margin: 5px" class="control-group ">
                                        <label for="id_addr-0-cn_name">中文姓名</label>                                 
                                        <input class="cn_fields cn_name" id="id_addr-0-cn_name" maxlength="24" name="addr-0-cn_name" style="width: 60px" type="text" value="<%:SheffieldOrder.Orders.First().Recipients.First().Name%>"  required="required" />
                                    </div>
                                    <div style="float: left; margin: 5px" class="control-group ">
                                        <label for="id_addr-0-cn_city">中文城市</label>
                                        <input class="cn_fields cn_city" id="id_addr-0-cn_city" maxlength="24" name="addr-0-cn_city" style="width: 60px" type="text" value="<%:SheffieldOrder.Orders.First().Recipients.First().City%>" required="required" />
                                    </div>
                                    <div style="float: left; margin: 5px" class="control-group ">
                                        <label for="id_addr-0-cn_street">中文地址</label>
                                        <input class="cn_fields cn_street" id="id_addr-0-cn_street" maxlength="72" name="addr-0-cn_street" style="width: 415px" type="text" value="<%:SheffieldOrder.Orders.First().Recipients.First().Address%>" required="required" />
                                    </div>
                                <div style="float: left; margin: 5px; margin-left: 17px; font-weight: bold">
                                        收件地<span style="padding: 2px 4px; background-color: #e1e1e1; font-weight: normal">中国大陆</span>
                                    </div>
                                    <div style="margin-left: 26px; float: left">
                                        <div style="float: left; margin: 5px 5px 5px 9px" class="control-group ">
                                            <label for="id_addr-0-postcode">邮编</label>
                                            <input id="id_addr-0-postcode" maxlength="6" name="addr-0-postcode" style="width: 60px" type="text" value="<%:SheffieldOrder.Orders.First().Recipients.First().ZipCode%>"  required="required"/>
                                        </div>
                                    </div>
                                    <div style="margin-left: 26px; float: left">
                                        <div style="float: left; margin: 5px 5px 5px 7px" class="control-group ">
                                            <label for="id_addr-0-phone">电话</label>
                                            <input id="id_addr-0-phone" maxlength="11" name="addr-0-phone" style="width: 100px" type="text" value="<%:SheffieldOrder.Orders.First().Recipients.First().PhoneNumber%>"  required="required"/>
                                        </div>
                                    </div>
                                    <div style="float: left; margin: 5px; margin-left: 20px" class="control-group">
                                        <label>
                                            额外保险
                                                    <select name="addr_0_insurance" class="addr_insurance" id="addr_0_insurance">
                                                        <option value="0">无</option>
                                                    </select>
                                        </label>
                                    </div>
                                    <div style="clear: both"></div>
                                    
                            </div>  
                        </div>
                    </li>

                    <asp:Repeater runat="server" ItemType="Order" SelectMethod="GetOrders">
                        <ItemTemplate>
                            <li class="addrItem" style="list-style: none; margin-top: 20px; background-color: #ffffcd; border: 1px solid #ddd">
                                <div class="clrw1" style="background-color: #FD7F23; padding: 5px 20px">
                                    <div class="pull-left" style="padding-top: 4px"><%#Item.SheffieldService.Name%></div>
                                    <div class="pull-right" style="padding-top: 4px">速递公司：<%#Item.PriceList.Name %></div>
                                    <div style="clear: both"></div>
                                </div>
                                <ol class="con" style="padding-left: 20px; padding-right: 10px; padding-bottom: 20px">
                                    <asp:Repeater runat="server" ItemType="Package" DataSource="<%#Item.Recipients.ElementAt(0).Packages %>">                                        
                                        <ItemTemplate>
                                            <li class="parcelItem" style="list-style: none; margin-top: 15px">
                                                <div class="rds1 clrw1" style="background-color: #0075C2; padding: 5px 20px">
                                                    包裹 <span><%#Container.ItemIndex + 1%></span>                                                    
                                                </div>
                                                <input id="id_parcel-0-address_id" name="parcel-0-address_id" type="hidden" value="0" />
                                                <input id="id_parcel-0-id" name="parcel-0-id" type="hidden" />
                                                <div class="rds2" style="padding-top: 10px; background-color: #E0EDF4; border: 1px solid #ddd;">
                                                    <div class="ib">
                                                        <div class="pd7 bold">重量/尺寸</div>
                                                        <div class="ib pd7">
                                                            重量(kg)
                                                            <div style="text-align:center">                                                                
                                                                 <span class="input-small" id="id_parcel-0-weight" name="parcel-0-weight" style="width: 55px"><strong><%#Item.Weight %></strong></span>
                                                            </div>
                                                        </div>
                                                        <div class="ib pd7">
                                                            长度(cm)                                   
                                                            <div style="text-align:center">
                                                                 <span class="input-small" id="id_parcel-0-length" name="parcel-0-length"" style="width: 55px"><strong><%#Item.Length %></strong></span>
                                                            </div>
                                                        </div>
                                                        <div class="ib pd7">
                                                            宽度(cm)                                   
                                                            <div style="text-align:center">
                                                                 <span class="input-small" id="id_parcel-0-width" name="parcel-0-width" style="width: 55px "><strong><%#Item.Width %></strong></span>
                                                            </div>
                                                        </div>
                                                        <div class="ib pd7">
                                                            高度(cm)                                
                                                            <div style="text-align:center">
                                                                 <span class="input-small" id="id_parcel-0-height" name="parcel-0-height" style="width: 55px"><strong><%#Item.Height %></strong></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="ib" style="margin-left: 20px">
                                                        <div>
                                                            <div class="ib pd7 bold">包裹明细</div>
                                                            <div class="ib pd7 bold" style="margin-left: 40px">
                                                                总额(£):<span class="mx_total"></span>
                                                            </div>
                                                        </div>

                                                        <!-- parcel content details -->

                                                        <div class="mx">
                                                            <div class="ib pd7">(<span class="mx_sq">1</span>)</div>
                                                            <div class="ib mx_type">
                                                                <select id="id_parcel-0-content-0-type" name="parcel-0-content-0-type" style="width: 100px">
                                                                    <option value="婴儿奶粉" selected="selected">婴儿奶粉</option>
                                                                    <option value="婴儿食品">婴儿食品</option>
                                                                    <option value="成人奶粉">成人奶粉</option>
                                                                    <option value="婴儿推车">婴儿推车</option>
                                                                    <option value="安全座椅">安全座椅</option>
                                                                    <option value="婴儿用品">婴儿用品</option>
                                                                    <option value="食品">食品</option>
                                                                    <option value="保健品">保健品</option>
                                                                    <option value="服装服饰">服装服饰</option>
                                                                    <option value="服饰配件">服饰配件</option>
                                                                    <option value="箱包">箱包</option>
                                                                    <option value="鞋靴">鞋靴</option>
                                                                    <option value="钟表">钟表</option>
                                                                    <option value="钟表配件">钟表配件</option>
                                                                    <option value="化妆品">化妆品</option>
                                                                    <option value="护肤品">护肤品</option>
                                                                    <option value="洗漱用品">洗漱用品</option>
                                                                    <option value="厨卫清洁用品">厨卫清洁用品</option>
                                                                    <option value="小家电（含游戏机等）">小家电（含游戏机等）</option>
                                                                    <option value="家用医疗用品">家用医疗用品</option>
                                                                    <option value="美容保健器材">美容保健器材</option>
                                                                    <option value="影音设备">影音设备</option>
                                                                    <option value="手机和移动设备">手机和移动设备</option>
                                                                    <option value="手机和移动设备配件">手机和移动设备配件</option>
                                                                    <option value="计算机">计算机</option>
                                                                    <option value="计算机外围设备">计算机外围设备</option>
                                                                    <option value="书报、刊物">书报、刊物</option>
                                                                    <option value="音响制品（唱片、影片等）">音响制品（唱片、影片等）</option>
                                                                    <option value="文具">文具</option>
                                                                    <option value="玩具">玩具</option>
                                                                    <option value="教育用品">教育用品</option>
                                                                    <option value="体育用品">体育用品</option>
                                                                    <option value="户外用品">户外用品</option>
                                                                    <option value="邮票">邮票</option>
                                                                    <option value="乐器">乐器</option>
                                                                    <option value="茶包">茶包</option>
                                                                    <option value="个人行李 - 旧箱包">个人行李 - 旧箱包</option>
                                                                    <option value="个人行李 - 旧文具">个人行李 - 旧文具</option>
                                                                    <option value="个人行李 - 旧电子物品">个人行李 - 旧电子物品</option>
                                                                    <option value="个人行李 - 旧护肤品">个人行李 - 旧护肤品</option>
                                                                    <option value="个人行李 - 个人礼品">个人行李 - 个人礼品</option>
                                                                    <option value="个人行李 - 旧衣物">个人行李 - 旧衣物</option>
                                                                </select>
                                                            </div>
                                                            <div class="ib mx_quantity mx_cal">
                                                                数量:                                                       
                                                                <input id="id_parcel-0-content-0-quantity" name="parcel-0-content-0-quantity" style="width: 40px" type="text" />
                                                            </div>
                                                            <div class="ib mx_cost mx_cal">
                                                                单价(£):                                                       
                                                                <input id="id_parcel-0-content-0-cost" name="parcel-0-content-0-cost" style="width: 40px" type="text" />
                                                            </div>
                                                            <div class="ib">
                                                                <button style="border: 1px solid #ddd; background: none" class="btn add_mx btn_mx" type="button" title="添加包裹明细"><i class="icon-plus icon-white"></i></button>
                                                            </div>
                                                            <div class="ib">
                                                                <button style="border: 1px solid #ddd; background: none" class="btn del_mx btn_mx" type="button" title="删除包裹明细"><i class="icon-minus"></i></button>
                                                            </div>
                                                        </div>
                                                        <input id="id_parcel-0-content-TOTAL_FORMS" name="parcel-0-content-TOTAL_FORMS" type="hidden" value="1" /><input id="id_parcel-0-content-INITIAL_FORMS" name="parcel-0-content-INITIAL_FORMS" type="hidden" value="0" /><input id="id_parcel-0-content-MAX_NUM_FORMS" name="parcel-0-content-MAX_NUM_FORMS" type="hidden" value="1000" />
                                                    </div>
                                                </div>
                                            </li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ol>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>                  
                </ol>
                <!-- terms -->
                <div style="border: 1px solid #ccc; padding: 10px; margin-top: 30px">

                    <div class="sz16 bold" style="padding: 10px 0">特别注意事项及服务条款</div>
                    <p>
                        在您下单之前，您需要认真阅读并同意以下条款，确认您的快递物品没有违反国际运输相关条例，并且检查您所申报的物品是否符合相关
        的保险赔偿条款。
                    </p>
                    <p>
                        １、我已经阅读并同意<a href="/conditions_terms/" target="_blank" style="color: #f00; float: none">诚信物流服务条款</a>，<a href="/privacy_policy/" target="_blank" style="color: #f00; float: none">个人隐私保护条款</a>，并且确认所快递物品符合相应国家出口及违禁品控制条例。<br />
                        ２、<span style="color: #f00; float: none">我同意若因本人提供的包裹尺寸或重量与运营商的测量不符，而导致额外费用，诚信物流有权从我所提供的银行卡信息对应的银行账户内扣除相应费用。</span><br />
                        ３、我同意由本人或相应收件人承担支付取货国家所产生的所有额外关税。（<a href="http://www.customs.gov.cn/publish/portal0/tab3889/module1188/info362458.htm" target="_blank" style="color: #f00; float: none">详见中国入境个人邮寄物品完税价格表</a>）<br />
                        ４、我确认所提供的包裹内物品信息（种类，数量，价格）与实际包裹内物品相符。
                    </p>


                    <label style="font-weight: bold">
                        <input type="checkbox" class="agreed" style="margin-top: -3px" />
                        我同意服务条款</label>
                </div>

            </div>

            <!-- right column -->
            <div class="col-sm-2 col-xs-12" style="border: 1px solid #69ADDB">
                <div class="panel" style="box-shadow: none">
                    <div style="margin-top: 10px">
                        <img src="../static/img/999parcel.png" style="width: 130px" />
                    </div>                    
                    <p>                       
                        <span style="font-size: small;">国际快递时间（不包括清关和旺季延误）: 6-10 天 /&nbsp;自带丢件赔偿: &pound;50磅 /&nbsp;包裹上可贴中文地址</span>
                    </p>

                    <div id="details">
                        <asp:Repeater runat="server" ItemType="Order" SelectMethod="GetOrders">
                            <ItemTemplate>
                                <br />
                                <%#Item.SheffieldService.Name %><br/><%#Item.Cost.Value.ToString("c", System.Globalization.CultureInfo.CreateSpecificCulture("en-GB")) %><br />
                                -----------------
                                <br/>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <br />
                    <p>总额:&nbsp;<span class="sz16 bold clrr1">£</span><span id="total" class="sz16 bold clrr1"><%:GetTotalPrice() %></span></p>
                    <div style="margin-bottom: 5px">
                        <input type="checkbox" class="agreed" style="margin-top: -3px" />
                                    我同意服务条款
                    </div>
                    <asp:Button runat="server" Enabled="false" name="order" ClientIDMode="Static" ID="add2cart" CssClass="btn btn-primary btn-large" Text="添加到购物车" OnClick="add2cart_Click" />
                </div>
            </div>
        </div>
    </form>

     <script>
         $(function () {
             $('.main-menu ul.nav li.dropdown').hover(
                 function () {
                     if ($('.main-menu .navbar-header').is(':hidden'))
                         $(this).addClass('open');
                 }, function () {
                     if ($('.main-menu .navbar-header').is(':hidden'))
                         $(this).removeClass('open');
                 }
             ).click(function (e) {
                 if ($('.main-menu .navbar-header').is(':visible')) {
                     var opened = $(this).hasClass('open');
                     $(this).siblings().removeClass('open').end().addClass('open');
                     if (!opened)
                         e.preventDefault();
                 }
             });
         });
    </script>


    <script src="/static/jquery-ui-1.11/jquery-ui.min.js"></script>
    <script src="/static/js/underscore-min.js"></script>
    <script type="text/javascript" src="/static/bootstrap-datetimepicker/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/static/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>

    <script src="/static/js/tree2.js?v=140902v2"></script>
    <script type="text/javascript">
        function smart_split(str, len) {
            var arr = str.split(' ');
            var arr2 = ['', '', '', ''], j = 0;
            var sep = ' ';

            for (var i = 0; i < arr.length; i++) {
                if ((arr2[j] + sep + arr[i]).length <= len)
                    if (arr2[j] == '')
                        arr2[j] += arr[i];
                    else
                        arr2[j] += sep + arr[i];
                else
                    if (j < 2) {
                        j += 1;
                        i -= 1;
                    }
                    else {
                        arr2[3] = arr[i];
                        break;
                    }
            }

            return arr2;
        }

        $(document).ready(function () {

            $('#tree').on('click', '.add_mx', function () {
                var mx = $(this).closest('.mx'),
                    mx_parent = mx.parent();
                if (mx_parent.find('.mx').length >= 10)
                    return;
                mx_parent.append(mx.clone());
                // update names
                $('#tree').find('.parcelItem').each(function (i) {
                    $(this).find('.mx').each(function (j) {
                        $(this).find('.mx_sq').html(j + 1);
                        $(this).find('select').attr('name', 'parcel-' + i + '-content-' + j + '-type');
                        $(this).find('input').eq(0).attr('name', 'parcel-' + i + '-content-' + j + '-quantity');
                        $(this).find('input').eq(1).attr('name', 'parcel-' + i + '-content-' + j + '-cost');
                        $(this).find('input').eq(2).attr('name', 'parcel-' + i + '-content-' + j + '-packet_id');
                    });
                    $(this).find('input[name$=-content-TOTAL_FORMS]').val($(this).find('.mx').length);
                    $(this).find('.mx_cal:first').blur();
                });
            });

            $('#tree').on('click', '.del_mx', function () {
                var mx = $(this).closest('.mx'),
                    mx_parent = mx.parent();
                if (mx_parent.find('.mx').length == 1)
                    return;
                mx.remove();
                // update names
                $('#tree').find('.parcelItem').each(function (i) {
                    $(this).find('.mx').each(function (j) {
                        $(this).find('.mx_sq').html(j + 1);
                        $(this).find('select').attr('name', 'parcel-' + i + '-content-' + j + '-type');
                        $(this).find('input').eq(0).attr('name', 'parcel-' + i + '-content-' + j + '-quantity');
                        $(this).find('input').eq(1).attr('name', 'parcel-' + i + '-content-' + j + '-cost');
                    });
                    $(this).find('input[name$=-content-TOTAL_FORMS]').val($(this).find('.mx').length);
                    $(this).find('.mx_cal:first').blur();
                });
            });

            // caculate total value on blur(change quantity/cost)
            $('#tree').on('blur', '.mx_cal', function () {
                var mx = $(this).closest('.mx'),
                    total = 0;
                mx.parent().find('.mx').each(function () {
                    var q = parseInt($(this).find('.mx_quantity input').val()),
                        c = parseFloat($(this).find('.mx_cost input').val());
                    if (!isNaN(q) && !isNaN(c))
                        total += q * c;
                });
                mx.parent().find('.mx_total').html(total);
            });

            // initial caculation
            $('#tree').find('.parcelItem').each(function () {
                $(this).find('.mx_cal:first').blur();
            });

            $('.agreed').click(function () {
                if ($(this).prop('checked')) {
                    $('.agreed').not($(this)).prop('checked', 'checked');
                    $('#add2cart').removeAttr('disabled');
                }
                else {
                    $('.agreed').not($(this)).removeAttr('checked');
                    $('#add2cart').prop('disabled', 'disabled');
                }
            });



            _.each([], function (v, k, lst) {
                $('#addr_' + k + '_insurance').val(v);
            });

            recalcAll();






            $('#tree').submit(function (e) {
                $('#root').find('[id$=-postcode]').each(function () {
                    if (/^[0-9]{6}$/.test($(this).val())) {
                        $(this).siblings('ul.errorlist').remove();
                    }
                    else {
                        e.preventDefault();
                        if ($(this).siblings('ul.errorlist').length == 0)
                            $(this).after('<ul class="errorlist"><li>必须是6位数字</li></ul>');
                    }
                });
                $('#root').find('[id$=-phone]').each(function () {
                    if (/^[0-9]{11}$/.test($(this).val())) {
                        $(this).siblings('ul.errorlist').remove();
                    }
                    else {
                        e.preventDefault();
                        if ($(this).siblings('ul.errorlist').length == 0)
                            $(this).after('<ul class="errorlist"><li>必须是11位数字</li></ul>');
                    }
                });
            });


            $('#root').on('keyup change', '.cn_fields', function () {
                var $this = $(this);
                var $addr_item = $this.closest('.addrItem');
                if ($this.data('timer'))
                    clearTimeout($this.data('timer'));
                var func = function (s) {
                    $addr_item.find('.py_fields').show();
                    if ($this.hasClass('cn_name')) {
                        if (s == '')
                            $addr_item.find('.py_name').html('&nbsp;');
                        else
                            $addr_item.find('.py_name').html(s);
                        $addr_item.find('.en_name').val(s);
                    }
                    if ($this.hasClass('cn_city')) {
                        var arr = smart_split(s, 24);
                        if (arr[1] == '')
                            $addr_item.find('.py_city').html(arr[0]);
                        else
                            $addr_item.find('.py_city').html(arr[0] + ' <span style="color:#f00">(字太多截断了请缩短中文城市)</span>');
                        $addr_item.find('.en_city').val(arr[0]);
                    }
                    if ($this.hasClass('cn_street')) {
                        var arr = smart_split(s, 24);
                        if (arr[3] == '')
                            $addr_item.find('.py_street').html(arr[0] + ' ' + arr[1] + ' ' + arr[2]);
                        else
                            $addr_item.find('.py_street').html(arr[0] + ' ' + arr[1] + ' ' + arr[2] + ' <span style="color:#f00">(字太多截断了请缩短中文地址)</span>');
                        $addr_item.find('.en_street').val(arr[0]);
                        $addr_item.find('.en_street2').val(arr[1]);
                        $addr_item.find('.en_street3').val(arr[2]);
                    }
                };
                var val = $.trim($this.val());

                if ($this.hasClass('cn_name'))
                    $addr_item.find('.cn_name_en').html(val);
                if ($this.hasClass('cn_city'))
                    $addr_item.find('.cn_city_en').html(val);
                if ($this.hasClass('cn_street'))
                    $addr_item.find('.cn_street_en').html(val);

                if (/^[a-zA-Z0-9 ]*$/.test(val))     // printable ascii chars
                    func(val.toUpperCase());
                else
                    $this.data('timer',
                        setTimeout(function () {
                            $.get('send2china.co.uk/pinyin/', { 's': val }, func);
                        }, 500)
                    );
            });

            $('.addrItem').each(function () {
                var $addr_item = $(this);
                $addr_item.find('.cn_fields').each(function () {
                    if ($(this).hasClass('cn_name'))
                        $addr_item.find('.cn_name_en').html($(this).val());
                    if ($(this).hasClass('cn_city'))
                        $addr_item.find('.cn_city_en').html($(this).val());
                    if ($(this).hasClass('cn_street'))
                        $addr_item.find('.cn_street_en').html($(this).val());
                });
                $addr_item.find('.en_fields').each(function () {
                    if ($(this).val() || $(this).siblings('ul.errorlist').length)
                        $addr_item.find('.py_fields').show();
                    if ($(this).hasClass('en_name')) {
                        $addr_item.find('.py_name').html($(this).val());
                        if ($(this).siblings('ul.errorlist').length) {
                            $addr_item.find('.py_name').append($(this).siblings('ul.errorlist').clone());
                            $addr_item.find('.py_fields').addClass('red-border');

                        }
                    }
                    if ($(this).hasClass('en_city')) {
                        $addr_item.find('.py_city').html($(this).val());
                        if ($(this).siblings('ul.errorlist').length) {
                            $addr_item.find('.py_city').append($(this).siblings('ul.errorlist').clone());
                            $addr_item.find('.py_fields').addClass('red-border');
                        }
                    }
                    if ($(this).hasClass('en_street')) {
                        $addr_item.find('.py_street').html($(this).val() + ' ' + $addr_item.find('.en_street2').val() + ' ' + $addr_item.find('.en_street3').val());
                        if ($(this).siblings('ul.errorlist').length) {
                            $addr_item.find('.py_street').append($(this).siblings('ul.errorlist').clone());
                            $addr_item.find('.py_fields').addClass('red-border');
                        }
                    }
                    if ($(this).hasClass('en_street2')) {
                        if ($(this).siblings('ul.errorlist').length) {
                            $addr_item.find('.py_street').append($(this).siblings('ul.errorlist').clone());
                            $addr_item.find('.py_fields').addClass('red-border');
                        }
                    }
                    if ($(this).hasClass('en_street3')) {
                        if ($(this).siblings('ul.errorlist').length) {
                            $addr_item.find('.py_street').append($(this).siblings('ul.errorlist').clone());
                            $addr_item.find('.py_fields').addClass('red-border');
                        }
                    }
                });
            });

            $('#root').on('click', '.display_hidden', function () {
                $(this).closest('.addrItem').find('.hidden_address').modal();
            });

            $('#root').on('click', '.change_translation', function () {
                var $addr_item = $(this).closest('.addrItem');
                $addr_item.find('.en_fields').each(function () {
                    if ($(this).hasClass('en_name'))
                        $addr_item.find('.py_name').html($(this).val());
                    if ($(this).hasClass('en_city'))
                        $addr_item.find('.py_city').html($(this).val());
                    if ($(this).hasClass('en_street'))
                        $addr_item.find('.py_street').html($(this).val() + ' ' + $addr_item.find('.en_street2').val() + ' ' + $addr_item.find('.en_street3').val());
                });
            });

            $('#root').on('click', '.translate', function () {
                $(this).closest('.addrItem').find('.cn_fields').trigger('change');
            });

            var $current_addr_item = 0;
            $('#root').on('click', '.select-addr2', function () {
                $current_addr_item = $(this).closest('.addrItem');
                $('#dialog-addrs').dialog({
                    modal: true,
                    width: 840,
                    height: 500
                });
            });

            $('#dialog-addrs').find('.recv_addr').click(function () {
                $('#dialog-addrs').dialog("close");
                var addr = recv_addr_dict[$(this).val()];
                if ($current_addr_item) {
                    $current_addr_item.find('[id$=cn_name]').val(addr[0]);
                    $current_addr_item.find('[id$=cn_city]').val(addr[1]);
                    $current_addr_item.find('[id$=cn_street]').val(addr[2]);
                    $current_addr_item.find('[id$=-name]').val(addr[3]);
                    $current_addr_item.find('[id$=-city]').val(addr[4]);
                    $current_addr_item.find('[id$=-street]').val(addr[5]);
                    $current_addr_item.find('[id$=street2]').val(addr[6]);
                    $current_addr_item.find('[id$=street3]').val(addr[7]);
                    $current_addr_item.find('[id$=postcode]').val(addr[8]);
                    $current_addr_item.find('[id$=phone]').val(addr[9]);
                }
                $current_addr_item.find('.en_fields').each(function () {
                    if ($(this).hasClass('en_name'))
                        $current_addr_item.find('.py_name').html($(this).val());
                    if ($(this).hasClass('en_city'))
                        $current_addr_item.find('.py_city').html($(this).val());
                    if ($(this).hasClass('en_street'))
                        $current_addr_item.find('.py_street').html($(this).val() + $current_addr_item.find('.en_street2').val() + $current_addr_item.find('.en_street3').val());
                });
                $current_addr_item.find('.py_fields').show();
            });

            $('#dialog-addrs').find('.del_addr_row').click(function () {
                var $addr_row = $(this).closest('.addr_row');
                var id = $addr_row.find('.recv_addr').val();
                if (confirm("你确定吗?"))
                    $.get('/rm_user_address/?id=' + id, function (data) {
                        if (data == 'done')
                            $addr_row.remove();
                    });
            });

            $('#lookup_name').keyup(function () {
                var re = new RegExp($(this).val(), "i");
                $('.addr_row').show().filter(function () {
                    return !re.test($(this).find('.addr-name').html());
                }).hide();
            });
        });


        var myStartDate = new Date();
        var myEndDate = new Date();
        if ($('#pickUpCompany')[0].innerText == 'UK Mail') {
            myStartDate.setDate(myStartDate.getDate() + 1);
        }

        myEndDate.setDate(myEndDate.getDate() + 7);

        $('.form_datetime').datetimepicker({
            format: 'yyyy/mm/dd',
            startDate: myStartDate,
            endDate: myEndDate,
            weekStart: 0,
            daysOfWeekDisabled: [0, 6],
            autoclose: true,
            startView: 2,
            minView: 2,
            maxView: 3,
            todayBtn: false,
            todayHighlight: false,
            minuteStep: 5,
            pickerPosition: 'bottom-right',
            showMeridian: false,
            clearBtn: false,
            language: 'en',
            //initialDate: '2015-04-1',
            daysDisabled: ['2014-04-18', '2014-04-21', '2014-05-05', '2014-05-26', '2014-08-25', '2014-12-24', '2014-12-25', '2014-12-26', '2015-01-01', '2015-04-03', '2015-04-06', '2015-05-04', '2015-05-25', '2015-08-31', '2015-12-25', '2015-12-28']
        });

        var toPinyin = function (zh, pinyin) {
            pinyin.innerText = ($('#' + pinyin).toPinyin());
        }
    </script>
</asp:Content>
