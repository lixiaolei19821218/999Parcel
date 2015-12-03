<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="products_Edit" MasterPageFile="~/MasterPage.master" EnableViewState="false"  %>

<%@ Import Namespace="System.Globalization" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>包裹信息 | 诚信物流-可靠,快捷,实惠</title>
     <%: System.Web.Optimization.Scripts.Render("~/bundle/jquery") %>
    <link rel="stylesheet" href="/static/jquery-ui-1.11/jquery-ui.min.css">
    <link rel="stylesheet" href="/static/font-awesome/css/font-awesome.min.css">

    <!--[if IE 7]>
      <link rel="stylesheet" href="/static/font-awesome/font-awesome-ie7.min.css">
    <![endif]-->

    <link href="/static/css/datetimepicker.css" type="text/css" media="all" rel="stylesheet" />
    <script type="text/javascript" src="/static/js/bootstrap-datetimepicker.js"></script>
    <script src="/static/bootstrap3/js/jquery-1.11.1.min.js"></script>

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

        .red-border {
            border: 1px solid #f00;
        }
    </style>




    <script type="text/javascript">
        $(function () {
            var Sys = {};
            var ua = navigator.userAgent.toLowerCase();
            var s;
            (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
            (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
            (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
            (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
            (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
            if (Sys.ie && parseFloat(Sys.ie) < 9)
                $('.check-br-ver').html('<div style="color:#f00;text-align:center">你的浏览器版本太低，请使用IE9.0以上版本，Google Chrome或者Firefox浏览器。</div>');
        });
    </script>

   
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
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

        .red-border {
            border: 1px solid #f00;
        }
    </style>






    <ul class="breadcrumb" style="background: none; margin-top: 15px">
    </ul>




    <div style="margin-top: 30px">
        <div style="margin-left: auto; margin-right: auto; width: 713px; padding-left: 12px; background: url(/static/img/buzou.png) 1px 0 no-repeat;">
            <a href="/" class="fl buzou" style="padding-left: 20px">快速询价</a>
            <a href="/products/" class="fl buzou" style="padding-left: 20px">产品选择</a>
            <a href="" class="fl buzou active" style="margin: 0 -14px; width: 150px">包裹信息</a>
            <a href="#" class="fl buzou" style="padding-left: 45px">在线支付</a>
            <a href="#" class="fl buzou" style="padding-left: 27px">邮件查收</a>
            <div class="cb"></div>
        </div>
    </div>

    <form class="form-inline" id="tree" method="post" runat="server">
        <input type='hidden' name='csrfmiddlewaretoken' value='T6iXH4VfX4yjoqPS3DTyrvWjpPcrC7Za' />
        <input id="id_addr-TOTAL_FORMS" name="addr-TOTAL_FORMS" type="hidden" value="2" /><input id="id_addr-INITIAL_FORMS" name="addr-INITIAL_FORMS" type="hidden" value="0" /><input id="id_addr-MAX_NUM_FORMS" name="addr-MAX_NUM_FORMS" type="hidden" value="1000" />
        <input id="id_parcel-TOTAL_FORMS" name="parcel-TOTAL_FORMS" type="hidden" value="3" /><input id="id_parcel-INITIAL_FORMS" name="parcel-INITIAL_FORMS" type="hidden" value="0" /><input id="id_parcel-MAX_NUM_FORMS" name="parcel-MAX_NUM_FORMS" type="hidden" value="1000" />

        <div class="row" style="background-color: #fff; padding: 20px 15px; margin: 20px 0 30px">
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

                 
                <script src="/static/js/crafty_postcode.class.js"></script>
                <script>
                    var cp_obj_1 = CraftyPostcodeCreate();
                    cp_obj_1.set("access_token", "17fa9-377f8-077dc-00faf");
                    cp_obj_1.set("first_res_line", "----- 请选择一个地址 ----");
                    cp_obj_1.set("res_autoselect", "0");
                    cp_obj_1.set("result_elem_id", "crafty_postcode_result_display_1");
                    cp_obj_1.set("form", "");
                    cp_obj_1.set("elem_street1", "id_billing_detail_street");
                    cp_obj_1.set("elem_street2", "id_billing_detail_street2");
                    cp_obj_1.set("elem_street3", "id_billing_detail_street3");
                    cp_obj_1.set("elem_town", "id_billing_detail_city");
                    cp_obj_1.set("elem_postcode", "id_billing_detail_postcode");
                    cp_obj_1.set("single_res_autoselect", 1);

                    $(function () {
                        $('#crafty_postcode_result_display_1').on('change', 'select', function () {
                            $('#crafty_postcode_result_display_1').html('');
                        });
                    });
                </script>

                <asp:Label ID="LabelError" runat="server" Text="Label" Visible="false" ForeColor="Red"></asp:Label>
                <ol id="root" style="padding-left: 0">                  

                    <asp:Repeater runat="server" ItemType="Recipient" SelectMethod="GetRecipients">
                        <ItemTemplate>
                            <li class="addrItem" style="list-style: none; margin-top: 20px; background-color: #ffffcd; border: 1px solid #ddd">
                                <div class="clrw1" style="background-color: #FD7F23; padding: 5px 20px">
                                    <div class="pull-left" style="padding-top: 4px">收件人 <span class="addr_item_num"><%#Container.ItemIndex + 1 %>: <%#Item.Name %></span></div>                                    
                                    <div class="del-addr pull-right btn btn-danger btn-small btn-hover"><i class="icon-trash icon-white"></i><span>删除收件人</span></div>
                                    <div class="add-addr pull-right btn btn-primary btn-small btn-hover"><i class="icon-plus icon-white"></i><span>添加收件人</span></div>
                                    <div style="clear: both"></div>
                                </div>
                                <input id="id_addr-0-id" name="addr-0-id" type="hidden" />
                                <!-- recipient address -->
                                <div style="padding-top: 10px" hidden="hidden">
                                    <div class="py_fields" style="position: relative; background-color: #e1e1e1; min-height: 24px; display: none; margin-left: 5px; margin-right: 5px; font-size: 13px">
                                        <div class="py_name" style="float: left; width: 162px; padding-left: 60px">&nbsp;</div>
                                        <div class="py_city" style="float: left; width: 162px; padding-left: 28px"></div>
                                        <div class="py_street" style="margin-left: 324px; margin-right: 38px"></div>
                                        <button class="display_hidden btn btn-small" type="button" style="position: absolute; right: 0; top: 0; background-color: #BFBFBF" title="修改转换">编辑</button>
                                        <div style="clear: both"></div>
                                    </div>
                                    <div style="float: left; margin: 5px" class="control-group ">
                                        <label for="id_addr-0-cn_name">中文姓名</label>

                                        <input class="cn_fields cn_name" id="id_addr-0-cn_name" maxlength="24" name="addr-0-cn_name" style="width: 60px" type="text" value="<%#Item.Name %>" />
                                    </div>
                                    <div style="float: left; margin: 5px" class="control-group ">
                                        <label for="id_addr-0-cn_city">中文城市</label>
                                        <input class="cn_fields cn_city" id="id_addr-0-cn_city" maxlength="24" name="addr-0-cn_city" style="width: 60px" type="text" value="<%#Item.City %>" />
                                    </div>
                                    <div style="float: left; margin: 5px" class="control-group ">
                                        <label for="id_addr-0-cn_street">中文地址</label>
                                        <input class="cn_fields cn_street" id="id_addr-0-cn_street" maxlength="72" name="addr-0-cn_street" style="width: 415px" type="text" value="<%#Item.Address %>" />
                                    </div>
                                    <div style="clear: both"></div>
                                    <div style="float: left; margin: 5px; margin-left: 17px; font-weight: bold">
                                        收件地<span style="padding: 2px 4px; background-color: #e1e1e1; font-weight: normal">中国大陆</span>
                                    </div>
                                    <div style="margin-left: 26px; float: left">
                                        <div style="float: left; margin: 5px" class="control-group ">
                                            <label for="id_addr-0-postcode">邮编</label>
                                            <input id="id_addr-0-postcode" maxlength="6" name="addr-0-postcode" style="width: 60px" type="text" value="<%#Item.ZipCode %>" />
                                        </div>
                                    </div>
                                    <div style="margin-left: 26px; float: left">
                                        <div style="float: left; margin: 5px" class="control-group ">
                                            <label for="id_addr-0-phone">电话</label>
                                            <input id="id_addr-0-phone" maxlength="11" name="addr-0-phone" style="width: 100px" type="text" value="<%#Item.PhoneNumber %>" />
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
                                    <div class="hidden_address modal fade" style="display: none; clear: both">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                                    <h4 class="modal-title" id="myModalLabel">英文／拼音地址手动输入</h4>
                                                </div>
                                                <div class="modal-body">
                                                    <div style="background-color: #e1e1e1">中文姓名：<span class="cn_name_en"></span></div>
                                                    <div style="float: left; margin: 5px" class="control-group ">
                                                        <label for="id_addr-0-name">姓名</label>
                                                        <input class="en_fields en_name" id="id_addr-0-name" maxlength="25" name="addr-0-name" style="width: 250px" type="text" />
                                                    </div>
                                                    <div style="clear: both"></div>
                                                    <div style="background-color: #e1e1e1">中文城市：<span class="cn_city_en"></span></div>
                                                    <div style="float: left; margin: 5px" class="control-group ">
                                                        <label for="id_addr-0-city">城市</label>
                                                        <input class="en_fields en_city" id="id_addr-0-city" maxlength="24" name="addr-0-city" style="width: 250px" type="text" />
                                                    </div>
                                                    <div style="clear: both"></div>
                                                    <div style="background-color: #e1e1e1">中文地址：<span class="cn_street_en"></span></div>
                                                    <div style="float: left; margin: 5px" class="control-group ">
                                                        <label for="id_addr-0-street">地址</label>
                                                        <input class="en_fields en_street" id="id_addr-0-street" maxlength="24" name="addr-0-street" style="width: 250px" type="text" />
                                                    </div>
                                                    <div style="float: left; margin: 5px" class="control-group ">
                                                        <input class="en_fields en_street2" id="id_addr-0-street2" maxlength="24" name="addr-0-street2" style="width: 250px; margin-left: 32px" type="text" />
                                                    </div>
                                                    <div style="float: left; margin: 5px" class="control-group ">
                                                        <input class="en_fields en_street3" id="id_addr-0-street3" maxlength="24" name="addr-0-street3" style="width: 250px; margin-left: 32px" type="text" />
                                                    </div>
                                                    <div style="clear: both"></div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-primary change_translation" data-dismiss="modal">确定</button>
                                                    <button type="button" class="btn btn-default translate">恢复拼音转换</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div style="float: left; margin: 5px; display: none" class="control-group">
                                        <label>
                                            <input type="checkbox" name="save_addr" checked="checked" value="1" class="save_addr" style="margin-bottom: 7px" />
                                            保存到地址簿
                                        </label>
                                    </div>
                                    <div style="clear: both"></div>
                                </div>

                                <ol class="con" style="padding-left: 20px; padding-right: 10px; padding-bottom: 20px">
                                    <asp:Repeater runat="server" ItemType="Package" EnableViewState="false" DataSource="<%#Item.Packages %>">                                        
                                        <ItemTemplate>
                                            <li class="parcelItem" style="list-style: none; margin-top: 15px">
                                                <div class="rds1 clrw1" style="background-color: #0075C2; padding: 5px 20px">
                                                    包裹 <span class="ordering_number">1</span>
                                                    <span class="del-parcel pull-right btn btn-danger btn-small btn-hover"><i class="icon-trash icon-white"></i><span>删除包裹</span></span>
                                                    <span class="clone pull-right btn btn-primary btn-small btn-hover"><i class="icon-plus icon-white"></i><span>添加包裹</span></span>
                                                </div>
                                                <input id="id_parcel-0-address_id" name="parcel-0-address_id" type="hidden" value="0" />
                                                <input id="id_parcel-0-id" name="parcel-0-id" type="hidden" />
                                                <div class="rds2" style="padding-top: 10px; background-color: #E0EDF4; border: 1px solid #ddd;">
                                                    <div class="ib">
                                                        <div class="pd7 bold">重量/尺寸</div>
                                                        <div class="ib pd7">
                                                            重量(kg)
                                                            <div>   
                                                                 <input onchange="" class="input-small" id="id_parcel-0-weight" name="parcel-0-weight" style="width: 55px" type="text" value="<%#Item.Weight %>" required="required" />
                                                            </div>
                                                        </div>
                                                        <div class="ib pd7">
                                                            长度(cm)                                   
                                                            <div>
                                                                <input onchange="" class="input-small" id="id_parcel-0-length" name="parcel-0-length" style="width: 55px" type="text" value="<%#Item.Length %>" required="required"/>
                                                            </div>
                                                        </div>
                                                        <div class="ib pd7">
                                                            宽度(cm)                                   
                                                            <div>
                                                                <input class="input-small" id="id_parcel-0-width" name="parcel-0-width" style="width: 55px" type="text" value="<%#Item.Width %>" required="required"/>
                                                            </div>
                                                        </div>
                                                        <div class="ib pd7">
                                                            高度(cm)                                
                                                            <div>
                                                                <input class="input-small" id="id_parcel-0-height" name="parcel-0-height" style="width: 55px" type="text" value="<%#Item.Height %>" required="required"/>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="ib" style="margin-left: 20px">                                                       
                                                        <!-- parcel content details -->
                                                     
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
            </div>

            <!-- right column -->
          
                    <div class="col-sm-2 col-xs-12" style="border: 1px solid #69ADDB">
                        <div class="panel" style="box-shadow: none">
                            <div style="margin-top: 10px">
                                <img src="/static/media/carriers/logo/bpost-logo.png" style="width: 130px" />
                            </div>

                            <p><strong>Bpost - Parcelforce取件</strong></p>
                            <p>
                                <p>
                                    <img src="/static/media/uploads/pf_collection.png" width="130" height="78" />
                                </p>
                                <p><span style="font-size: small;">国际快递时间（不包括清关和旺季延误）: 6-10 天 /&nbsp;自带丢件赔偿: &pound;50磅 /&nbsp;包裹上可贴中文地址</span></p>
                            </p>       
                                                   
                            <asp:Button Width="120" ID="ButtonToOrder" runat="server" CssClass="btn btn-primary btn-large" Text="返回订单" OnClick="ButtonToOrder_Click" />
                                
                        </div>
                        <!-- .panel -->
                    </div>

            

        </div>
    </form>








    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

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
                            $.get('/pinyin/', { 's': val }, func);
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
    </script>


    <script type="text/javascript" src="/static/bootstrap-datetimepicker/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/static/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>

    <script type="text/javascript">


        $('.form_datetime').datetimepicker({
            format: 'yyyy-mm-dd',
            //startDate: date,
            //endDate: '2015-03-12',
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
            //initialDate: '2015-03-10',
            daysDisabled: ['2014-04-18', '2014-04-21', '2014-05-05', '2014-05-26', '2014-08-25', '2014-12-24', '2014-12-25', '2014-12-26', '2015-01-01', '2015-04-03', '2015-04-06', '2015-05-04', '2015-05-25', '2015-08-31', '2015-12-25', '2015-12-28']
        });
        $('.form_date').datetimepicker({
            language: 'en',
            weekStart: 1,
            todayBtn: 1,
            autoclose: 1,
            todayHighlight: 1,
            startView: 2,
            minView: 2,
            forceParse: 0
        });
        $('.form_time').datetimepicker({
            format: 'yyyy-mm-dd',
            startDate: '2015-03-10',
            endDate: '2015-03-12',
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
            initialDate: '2015-03-10',
            daysDisabled: ['2014-04-18', '2014-04-21', '2014-05-05', '2014-05-26', '2014-08-25', '2014-12-24', '2014-12-25', '2014-12-26', '2015-01-01', '2015-04-03', '2015-04-06', '2015-05-04', '2015-05-25', '2015-08-31', '2015-12-25', '2015-12-28']
        });
    </script>
</asp:Content>
