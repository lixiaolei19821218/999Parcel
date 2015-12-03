<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Product.aspx.cs" Inherits="products_Product" MasterPageFile="~/MasterPage.master" EnableViewState="false"  %>

<%@ Import Namespace="System.Globalization" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>填写订单信息 | 诚信物流-可靠,快捷,实惠</title>

     <%: System.Web.Optimization.Scripts.Render("~/bundle/jquery") %>
    <script type="text/javascript" src="../Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="../Scripts/jQuery.Hz2Py-min.js"></script>
     
    <script>
        $(document).ready(function () {
            $("button").click(function (e) {
                var inputElem = $("#Name")[0];
                if (inputElem.checkValidity() && !inputElem.validity.customError) {
                    var length = inputElem.value.length;
                    if (length < 5 || length > 20) {
                        inputElem.setCustomValidity("Name must be 5-20 characters");
                    }
                } else {
                    inputElem.setCustomValidity("");
                }
            });

        });
    </script>

    <link rel="stylesheet" href="/static/jquery-ui-1.11/jquery-ui.min.css">
    <link rel="stylesheet" href="/static/font-awesome/css/font-awesome.min.css">

    <!--[if IE 7]>
      <link rel="stylesheet" href="/static/font-awesome/font-awesome-ie7.min.css">
    <![endif]-->

    <link href="/static/css/datetimepicker.css" type="text/css" media="all" rel="stylesheet" />
    <script type="text/javascript" src="/static/js/bootstrap-datetimepicker.js"></script>    

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
   
    <ul class="breadcrumb" style="background: none; margin-top: 15px">
    </ul>




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

                <asp:Label ID="LabelError" runat="server" Text="Label" ForeColor="Red" Visible="false"></asp:Label>
                <ol id="root" style="padding-left: 0">
                    <li style="list-style: none">

                        <!-- sender address -->
                        <div class="bg1 rds1 clrw1" style="height: 38px; background-position: 0 0; background-repeat: repeat-x; padding: 10px 20px">
                            发件人地址（英国）
                        </div>

                        <div class="rds2" style="border: 1px solid #ddd; background-color: #F2F8FC; padding: 5px 1px">
                            <div style="float: left; margin: 5px" class="control-group ">
                                <label for="id_billing_detail_name">姓名</label>
                                <input class="input-medium" id="id_billing_detail_name" maxlength="25" name="billing_detail_name" style="width: 115px" type="text" value="<%:Order.SenderName %>" required="required"/>


                            </div>
                            <div style="float: left; margin: 5px" class="control-group ">
                                <label for="id_billing_detail_street">地址</label>
                                <input class="input-xxlarge" id="id_billing_detail_street" maxlength="24" name="billing_detail_street" style="width: 180px" type="text" value="<%:Order.SenderAddress1 %>" required="required"/>




                            </div>
                            <div style="float: left; margin: 5px" class="control-group ">
                                <input class="input-medium" id="id_billing_detail_street2" maxlength="24" name="billing_detail_street2" style="width: 180px" type="text" value="<%:Order.SenderAddress2 %>" />




                            </div>
                            <div style="float: left; margin: 5px" class="control-group ">
                                <input class="input-medium" id="id_billing_detail_street3" maxlength="24" name="billing_detail_street3" style="width: 173px" type="text" value="<%:Order.SenderAddress3 %>" />




                            </div>
                            <div style="clear: both"></div>

                            <div style="float: left; margin: 5px" class="control-group ">
                                <label for="id_billing_detail_city">城市</label>
                                <input class="input-medium" id="id_billing_detail_city" maxlength="24" name="billing_detail_city" style="width: 115px" type="text" value="<%:Order.SenderCity %>" required="required"/>




                            </div>
                            <div style="float: left; margin: 5px" class="control-group ">
                                <label for="id_billing_detail_phone">电话</label>
                                <input class="input-medium" id="id_billing_detail_phone" maxlength="15" name="billing_detail_phone" style="width: 180px" type="text" value="<%:Order.SenderPhone %>" required="required" title="请输入数字" pattern="\d+"/>




                            </div>
                            <div style="float: left; margin: 5px" class="control-group ">
                                <label for="id_billing_detail_postcode">邮编</label>
                                <input class="input-medium" id="id_billing_detail_postcode" maxlength="8" name="billing_detail_postcode" style="width: 100px" type="text" value="<%:Order.SenderZipCode %>" required="required" onchange="zip_code_change()" />
                                

                            </div>

                            

                            <div id="crafty_postcode_result_display_1" style="float: left; margin: 5px"></div>

                            <div style="clear: both; display: none">
                                <div style="float: left; margin: 5px" class="control-group ">
                                    <label for="id_billing_detail_email">Email</label>
                                    <input class="input-medium" id="id_billing_detail_email" maxlength="50" name="billing_detail_email" style="width: 180px" type="text" value="<%:Order.SenderZipCode %>" />
                                    



                                </div>
                            </div>

                            <div style="clear: both"></div>
                        </div>

                        <div style="margin-top: 10px;">
                            <div class="clrw1 rds1" style="background-color: #7F7983; padding: 5px 20px">
                                取件安排
                            </div>
                            <div class="rds2" style="padding: 5px 2px; border: 1px solid #ddd; background-color: #F2F8FC">
                                <div style="float: left; margin: 5px; font-weight: bold; margin-right: 10px">取件公司 <span id="pickUpCompany" style="background-color: #e1e1e1; padding: 2px 4px; font-size: 12px; font-weight: normal"><%:ServiceView.PickUpCompany %></span></div>

                                <div style="float: left; margin: 5px" class="control-group ">
                                    <label for="id_pickup_time_0">日期</label>
                                    <div class="input-append date form_datetime">
                                        <input class="input-medium" foo_bar="prevent_readonly" id="id_pickup_time_0" name="pickup_time_0" type="text" value="<%:Order.PickupTime.HasValue ? Order.PickupTime.Value.ToShortDateString() : null %>"  required="required"/>
                                        <span id="sp" class="add-on"><i class="icon-th"></i></span>
                                    </div>                                   
                                </div>
                                <div style="float: left; margin: 5px; font-weight: bold; margin-left: 10px; margin-right: 10px">
                                    时间

                    
                        <span style="font-size: 12px; font-weight: normal">
                            <span runat="server" id="pfuk">9:00-18:30</span>
                            <select runat="server" id="_999parcel" ClientIDMode="Static">
                                <option value="am" id="am" >9:00-11:00</option>
                                <option value="pm" id="pm" >13:00-15:00</option>
                            </select>
                        </span>


                                </div>

                                <div style="float: left; margin: 5px" class="control-group " hidden="hidden">
                                    <label for="id_additional_instructions">备注</label>
                                    <input class="input-xxlarge" id="id_additional_instructions" maxlength="50" name="additional_instructions" style="width: 270px" type="text" />




                                </div>
                                <div style="clear: both"></div>
                            </div>
                        </div>
                    </li>
                    
                    <asp:Repeater runat="server" ItemType="Recipient" SelectMethod="GetRecipients">
                        <ItemTemplate>
                           
                            <li class="addrItem" style="list-style: none; margin-top: 20px; background-color: #ffffcd; border: 1px solid #ddd">
                                <div class="clrw1" style="background-color: #FD7F23; padding: 5px 20px">
                                    <div class="pull-left" style="padding-top: 4px">收件人地址 <span class="addr_item_num"><%#Container.ItemIndex + 1 %></span></div>
                                    <div class="select-addr2 pull-left btn btn-primary btn-small btn-hover"><i class="icon-book icon-white"></i><span>调用地址簿</span></div>                                    
                                    <div style="clear: both"></div>
                                </div>
                                <input id="id_addr-0-id" name="addr-0-id" type="hidden" />
                                <!-- recipient address -->
                                <div style="padding-top: 10px"> 
                                    <div class="py_fields" style="position: relative; background-color: #e1e1e1; min-height: 24px; display:normal; margin-left: 5px; margin-right: 5px; font-size: 13px">
                                        <div style="float: left; width: 162px; padding-left: 60px" id="py_name<%#Container.ItemIndex %>"><%#Item.PyName %></div><input type="hidden" value="<%#Item.PyName %>" name="hd_name<%#Container.ItemIndex %>" id="hd_name<%#Container.ItemIndex %>"></input>
                                        <div style="float: left; width: 162px; padding-left: 28px" id="py_city<%#Container.ItemIndex %>"><%#Item.PyCity %></div><input type="hidden" value="<%#Item.PyCity %>" name="hd_city<%#Container.ItemIndex %>" id="hd_city<%#Container.ItemIndex %>"></input>
                                        <div style="margin-left: 324px; margin-right: 38px" id="py_street<%#Container.ItemIndex %>"><%#Item.PyAddress %></div><input type="hidden" value="<%#Item.PyAddress %>" name="hd_street<%#Container.ItemIndex %>" id="hd_street<%#Container.ItemIndex %>"></input>
                                        <button class="display_hidden btn btn-small" type="button" style="position: absolute; right: 0; top: 0; background-color: #BFBFBF" title="修改转换">编辑</button>
                                       
                                    </div>
                                    
                                    <div style="float: left; margin: 5px" class="control-group ">
                                        <label for="id_addr-0-cn_name">中文姓名</label>                                 
                                        <input class="cn_fields cn_name" id="id_addr-0-cn_name" maxlength="24" name="addr-0-cn_name" style="width: 60px" type="text" value="<%#Item.Name %>"  required="required" 
                                            onblur="var py=($('#id_addr-<%#Container.ItemIndex %>-cn_name').toPinyin());py_name<%#Container.ItemIndex %>.innerText=py;hd_name<%#Container.ItemIndex %>.value=py;" 
                                            onchange="var py=($('#id_addr-<%#Container.ItemIndex %>-cn_name').toPinyin());py_name<%#Container.ItemIndex %>.innerText=py;hd_name<%#Container.ItemIndex %>.value=py;" 
                                            onkeydown="var py=($('#id_addr-<%#Container.ItemIndex %>-cn_name').toPinyin());py_name<%#Container.ItemIndex %>.innerText=py;hd_name<%#Container.ItemIndex %>.value=py;"/>
                                    </div>
                                    <div style="float: left; margin: 5px" class="control-group ">
                                        <label for="id_addr-0-cn_city">中文城市</label>
                                        <input class="cn_fields cn_city" id="id_addr-0-cn_city" maxlength="24" name="addr-0-cn_city" style="width: 60px" type="text" value="<%#Item.City %>" required="required" 
                                            onblur="var py=($('#id_addr-<%#Container.ItemIndex %>-cn_city').toPinyin());py_city<%#Container.ItemIndex %>.innerText=py;hd_city<%#Container.ItemIndex %>.value=py;"
                                            onchange="var py=($('#id_addr-<%#Container.ItemIndex %>-cn_city').toPinyin());py_city<%#Container.ItemIndex %>.innerText=py;hd_city<%#Container.ItemIndex %>.value=py;" 
                                            onkeydown="var py=($('#id_addr-<%#Container.ItemIndex %>-cn_city').toPinyin());py_city<%#Container.ItemIndex %>.innerText=py;hd_city<%#Container.ItemIndex %>.value=py;"/>
                                    </div>
                                    <div style="float: left; margin: 5px" class="control-group ">
                                        <label for="id_addr-0-cn_street">中文地址</label>
                                        <input class="cn_fields cn_street" id="id_addr-0-cn_street" maxlength="30" name="addr-0-cn_street" style="width: 415px" type="text" value="<%#Item.Address %>" required="required" 
                                            onblur="var py=($('#id_addr-<%#Container.ItemIndex %>-cn_street').toPinyin());py_street<%#Container.ItemIndex %>.innerText=py;hd_street<%#Container.ItemIndex %>.value=py;" 
                                            onchange="var py=($('#id_addr-<%#Container.ItemIndex %>-cn_street').toPinyin());py_street<%#Container.ItemIndex %>.innerText=py;hd_street<%#Container.ItemIndex %>.value=py;" 
                                            onkeydown="var py=($('#id_addr-<%#Container.ItemIndex %>-cn_street').toPinyin());py_street<%#Container.ItemIndex %>.innerText=py;hd_street<%#Container.ItemIndex %>.value=py;"/>
                                    </div>
                                    <div style="clear: both"></div>
                                    <div style="float: left; margin: 5px; margin-left: 17px; font-weight: bold">
                                        收件地<span style="padding: 2px 4px; background-color: #e1e1e1; font-weight: normal">中国大陆</span>
                                    </div>
                                    <div style="margin-left: 26px; float: left">
                                        <div style="float: left; margin: 5px 5px 5px 9px" class="control-group ">
                                            <label for="id_addr-0-postcode">邮编</label>
                                            <input id="id_addr-0-postcode" maxlength="6" name="addr-0-postcode" style="width: 60px" type="text" value="<%#Item.ZipCode %>"  required="required"/>
                                        </div>
                                    </div>
                                    <div style="margin-left: 26px; float: left">
                                        <div style="float: left; margin: 5px 5px 5px 7px" class="control-group ">
                                            <label for="id_addr-0-phone">电话</label>
                                            <input id="id_addr-0-phone" maxlength="11" name="addr-0-phone" style="width: 100px" type="text" value="<%#Item.PhoneNumber %>"  required="required"/>
                                        </div>
                                    </div>                                   
                                    <div style="float: left; margin: 5px; margin-left: 20px;" class="control-group" <%:ServiceView.Name.Contains("Parcelforce Priority") ? "" : "hidden=\"hidden\"" %> >
                                        <label runat="server" id="label">
                                            额外保险
                                                    <select name="addr_0_insurance" class="addr_insurance" id="addr_0_insurance">
                                                        <option value="0">无</option>
                                                        <option value="0">£5</option>
                                                        <option value="0">£10</option>
                                                        <option value="0">£15</option>
                                                        <option value="0">£20</option>
                                                        <option value="0">£25</option>
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

                                                    <div class="ib" style="margin-left: 10px">
                                                        <div>
                                                            <div class="ib pd7 bold">包裹明细</div>

                                                            <div class="ib pd7 bold" style="margin-left: 128px">
                                                                总额(£):
                                        <span class="mx_total"></span>
                                                            </div>

                                                        </div>

                                                        <!-- parcel content details -->
                                                        <asp:Repeater runat="server" DataSource="<%#Item.PackageItems %>" ItemType="PackageItem">
                                                            <ItemTemplate>
                                                                <div class="mx">
                                                                    <div class="ib">(<span class="mx_sq"><%#Container.ItemIndex + 1%></span>)</div>
                                                                    <div class="ib mx_type">
                                                                        <select class="item_detail" id="id_parcel-0-content-<%#Container.ItemIndex %>-type" name="parcel-0-content-<%#Container.ItemIndex %>-type" style="width: 100px">
                                                                            <option value="Baby Milk Powder" selected="selected">婴儿奶粉</option>
                                                                            <option value="Baby Food">婴儿食品</option>
                                                                            <option value="Adult Milk Powder">成人奶粉</option>
                                                                            <option value="Strollers">婴儿推车</option>
                                                                            <option value="Baby Car Seats">安全座椅</option>
                                                                            <option value="Baby Product">婴儿用品</option>
                                                                            <option value="Food">食品</option>
                                                                            <option value="Health Care">保健品</option>
                                                                            <option value="Clothing">服装服饰</option>
                                                                            <option value="Accessories">服饰配件</option>
                                                                            <option value="Bag">箱包</option>
                                                                            <option value="Shoes">鞋靴</option>
                                                                            <option value="Watches">钟表</option>
                                                                            <option value="Watch Accessories">钟表配件</option>
                                                                            <option value="Cosmetic">化妆品</option>
                                                                            <option value="Skincare">护肤品</option>
                                                                            <option value="Toiletries">洗漱用品</option>
                                                                            <option value="Kitchen Cleaning Supplies">厨卫清洁用品</option>
                                                                            <option value="Electric Products">小家电（含游戏机等）</option>
                                                                            <option value="Home Medical Equipment">家用医疗用品</option>
                                                                            <option value="Beauty Apparatus">美容保健器材</option>
                                                                            <option value="Visual Equipment">影音设备</option>
                                                                            <option value="Mobile Phones and Devices">手机和移动设备</option>
                                                                            <option value="Mobile Phones and Devices Accessories">手机和移动设备配件</option>
                                                                            <option value="Computer">计算机</option>
                                                                            <option value="Computer Peripherals">计算机外围设备</option>
                                                                            <option value="Books and Newspapers">书报、刊物</option>
                                                                            <option value="Impact products">音响制品（唱片、影片等）</option>
                                                                            <option value="Stationary">文具</option>
                                                                            <option value="Toys">玩具</option>
                                                                            <option value="Educational Supplies">教育用品</option>
                                                                            <option value="Sporting Goods">体育用品</option>
                                                                            <option value="Outdoor Product">户外用品</option>
                                                                            <option value="Stamp">邮票</option>
                                                                            <option value="Musical Instruments">乐器</option>
                                                                            <option value="Tea">茶包</option>
                                                                            <option value="汽车配件">汽车配件</option>
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
                                                               <input id="id_parcel-0--content-<%#Container.ItemIndex %>-quantity" name="parcel-0-content-<%#Container.ItemIndex %>-quantity" style="width: 50px" type="number" min="1" max="999999" value="<%#Item.Count %>" required="required"/>

                                                                    </div>

                                                                    <div class="ib mx_cost mx_cal">
                                                                        单价(£):
                                                               <input id="id_parcel-0-content-<%#Container.ItemIndex %>-cost" name="parcel-0-content-<%#Container.ItemIndex %>-cost" style="width: 50px" type="number" min="0" max="999999" value="<%#Item.Value %>" required="required"/>
                                                                    </div>

                                                                    <div class="ib">
                                                                        <button style="border: 1px solid #ddd; background: none" class="btn add_mx btn_mx" type="button" title="添加包裹明细"><i class="icon-plus icon-white"></i></button>
                                                                    </div>
                                                                    <div class="ib">
                                                                        <button style="border: 1px solid #ddd; background: none" class="btn del_mx btn_mx" type="button" title="删除包裹明细"><i class="icon-minus"></i></button>
                                                                    </div>
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:Repeater>

                                                        <input id="id_parcel-<%#Container.ItemIndex %>-content-TOTAL_FORMS" name="parcel-<%#Container.ItemIndex %>-content-TOTAL_FORMS" type="hidden" value="<%#Item.PackageItems.Count %>" /><input id="id_parcel-0-content-INITIAL_FORMS" name="parcel-0-content-INITIAL_FORMS" type="hidden" value="0" /><input id="id_parcel-0-content-MAX_NUM_FORMS" name="parcel-0-content-MAX_NUM_FORMS" type="hidden" value="1000" />
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
                                <img src="<%:ServiceView.PictureLink %>" style="width: 130px" />
                            </div>

                            <p><strong><%:ServiceView.Name %></strong></p>
                            <p>
                                <p>
                                    <img src=<%:ServiceView.DiscribePictureLink %> width="130" height="78" />
                                </p>
                                <p><span style="font-size: small;">国际快递时间（不包括清关和旺季延误）: 6-10 天 /&nbsp;自带丢件赔偿: &pound;50磅 /&nbsp;包裹上可贴中文地址</span></p>
                            </p>

                            <div id="details">
                                <br />
                                <%:ServiceView.PickUpCompany %>:
                                <br />
                                <span id="pickup_price"><%:ServiceView.GetPickupPrice(Order).ToString("c", CultureInfo.CreateSpecificCulture("en-GB")) %></span>
                                <br />
                               
                                <asp:Repeater runat="server" ItemType="Package" SelectMethod="GetAllPackages">
                                    <ItemTemplate>
                                        <br />
                                        包裹 <%#Container.ItemIndex + 1 %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%#GetPackagePrice(Item).ToString("c", CultureInfo.CreateSpecificCulture("en-GB")) %><br />-----------------
                                    </ItemTemplate>
                                </asp:Repeater>                                
                               
                            </div>
                            <br />
                            <p>总额: <span id="total" class="sz16 bold clrr1"><%:GetSendPrice().ToString("c", CultureInfo.CreateSpecificCulture("en-GB")) %></span></p>
                            <div style="margin-bottom: 5px">
                                <label style="font-weight: bold">
                                    <input type="checkbox" class="agreed" style="margin-top: -3px" />
                                    我同意服务条款
                                </label>
                            </div>
                            <asp:Button runat="server" name="order" ClientIDMode="Static" ID="add2cart" CssClass ="btn btn-primary btn-large" Text="下一步" Enabled="false" OnClick="add2cart_Click" Width="120" />
               
                                           <div style="margin:10px">

                                               <asp:Button ID="LinkButtonEdit" runat="server" style="width: 100px; height: 23px; border: none; background-color:transparent; font-size: 12px; color:steelblue" OnClick="LinkButtonEdit_Click" Text="添加/修改包裹"></asp:Button>
                                           </div>
                        </div>
                        <!-- .panel -->
                    </div>                  
            

        </div>
    </form>


    <div id="dialog-pinyin" title="中文转为拼音" style="display: none">
        <p style="font-size: 14px; margin-top: 20px; font-style: italic">输入中文地址，点击翻译，转换为汉语拼音，点击确定，把翻译后的汉语拼音输入收件人地址。</p>
        <div style="margin-top: 20px; margin-bottom: 15px; font-size: 20px; font-weight: bold;">中文：</div>
        <div>
            姓名:
                    <input type="text" id="py_name" style="width: 100px" />
            &nbsp;
        城市:
                    <input type="text" id="py_city" style="width: 100px" />
            &nbsp;
        邮编:
                    <input type="text" id="py_zip" style="width: 100px" />
            &nbsp;
        电话:
                    <input type="text" id="py_phone" style="width: 140px" />
            &nbsp;
        </div>
        <div>
            地址:
                    <input type="text" id="py_street" style="width: 650px" />
        </div>

        <div style="margin-top: 20px; margin-bottom: 15px; font-size: 20px; font-weight: bold;">拼音：</div>
        <div>
            姓名:
                    <input type="text" id="py2_name" style="width: 100px" />
            &nbsp;
        城市:
                    <input type="text" id="py2_city" style="width: 100px" />
            &nbsp;
        邮编:
                    <input type="text" id="py2_zip" style="width: 100px" />
            &nbsp;
        电话:
                    <input type="text" id="py2_phone" style="width: 140px" />
            &nbsp;
        </div>
        <div>
            地址:
                    <input type="text" id="py2_street1" />
            <input type="text" id="py2_street2" />
            <input type="text" id="py2_street3" />
        </div>
    </div>

    <div id="dialog-addrs" title="地址簿" style="background-color: #fff; display: none; font-size: 13px">

        <style style="text/css">
            
                  bac groun
            
                margin: 1px 0;
        }

                .ad _ro :
                ver {
                
                     ;
             
                    background-color: d;
                }
        </style>
        <script>var recv_addr_dict = {};</script>

        <div style="margin: 10px 0"><span>输入姓名过滤：</span><input type="text" id="lookup_name" /></div>

        <div>
            <div style="display: inline-block; width: 100px">姓名</div>
            <div style="display: inline-block; width: 100px">城市</div>
            <div style="display: inline-block; width: 56px">邮编</div>
            <div style="display: inline-block; width: 477px">地址</div>
        </div>


        <div class="addr_row">
            <button type="button" style="float: right; margin-top: 5px" class="btn btn-danger btn-small del_addr_row" title="删除"><i class="icon-trash icon-white"></i></button>
            <label style="display: block; margin-right: 40px">
                <input type="radio" name="recv_addr" class="recv_addr" value="45816" style="display: none" />
                <div style="display: inline-block; width: 100px" class="addr-name">
                    1<br />
                    1
                </div>
                <div style="display: inline-block; width: 100px">
                    1<br />
                    1
                </div>
                <div style="display: inline-block; width: 56px">610000</div>
                <div style="display: inline-block; width: 477px">
                    1<br />
                    1 
                </div>
            </label>
        </div>

      
        
        
        

       

      

    </div>






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

            var item_details = new Array(<%=GetDetails()%>);
            
            for (var i = 0; i < $('.item_detail').length; i++)
            {
                $('.item_detail')[i].value = item_details[i];
            }
        });

        var today = new Date();
        var myStartDate = new Date();
        var myEndDate = new Date();



        if ($('#pickUpCompany')[0].innerText == 'UK Mail' || $('#pickUpCompany')[0].innerText == 'Parcelforce') {
            myStartDate.setDate(today.getDate() + 1);
            myEndDate.setDate(today.getDate() + 2);
        }
        else {
            if (today.getHours() > 15) {
                myStartDate.setDate(today.getDate() + 1);
            }

            myEndDate.setDate(myEndDate.getDate() + 7);

        }

        if ($('#pickUpCompany')[0].innerText == '999Parcel') {
            $('#id_billing_detail_postcode')[0].pattern = "[Ss](1|2|3|4|5|6||8|9|10|11|12|13|14|17|20|21|25|26|35|36)\\s\\w+";
            $('#id_billing_detail_postcode')[0].title = "请输入诚信物流取件地区的邮编";
        }
        else {
            //$('#id_billing_detail_postcode')[0].pattern = '[Ss]\\d{1,2}\\s\\w+';
            //$('#id_billing_detail_postcode')[0].title = "请输入谢菲尔德地区的邮编";
        }

        $('.form_datetime').datetimepicker({
            format: 'yyyy/mm/dd',
            startDate: myStartDate,
            endDate: myEndDate,
            weekStart: 0,
            daysOfWeekDisabled: [6],
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
            initialDate: myStartDate,

            daysDisabled: ['2014-04-18', '2014-04-21', '2014-05-05', '2014-05-26', '2014-08-25', '2014-12-24', '2014-12-25', '2014-12-26', '2015-01-01', '2015-04-03', '2015-04-06', '2015-05-04', '2015-05-25', '2015-08-31', '2015-12-25', '2015-12-28']
        });

        $('.form_datetime').datetimepicker().on('changeDate', function (ev) {
            if ($('#pickUpCompany')[0].innerText == '999Parcel') {


                var selected = new Date($('#id_pickup_time_0')[0].value);
                if (selected.getDate() == today.getDate()) {
                    if (today.getHours() > 9) {
                        $('#am')[0].hidden = true;
                        $('#_999parcel')[0].selectedIndex = 1;
                    }

                }
                else {
                    $('#am')[0].hidden = false;
                }
            }
        });

        var toPinyin = function (zh, pinyin) {
            pinyin.innerText = ($('#' + pinyin).toPinyin());
        }

        //$('#billing_detail_postcode')[0].
        var areas_free = "<%=FreeAreas%>".split(',');
        var areas_3pounds = "<%=ChargedAreas%>".split(',');
        var price = parseFloat("<%=ChargePrice%>");
        var free = 0.0;

        var oldPickup = parseFloat($('#pickup_price')[0].innerText.replace('£', ''));
        var sendPrice = parseFloat($('#total')[0].innerText.replace('£', '')) - oldPickup;

        function zip_code_change() {
            if ($('#pickUpCompany')[0].innerText == '999Parcel') {
                var zip_code = new String();
                zip_code = $('#id_billing_detail_postcode')[0].value;

                var head = zip_code.split(' ')[0];
                if ($.inArray(head, areas_free) != -1) {
                    $('#pickup_price')[0].innerText = '£' + free.toFixed(2);
                    $('#total')[0].innerText = '£' + (free + sendPrice).toFixed(2);
                }
                else if ($.inArray(head, areas_3pounds) != -1) {
                    $('#pickup_price')[0].innerText = '£' + price.toFixed(2);
                    $('#total')[0].innerText = '£' + (price + sendPrice).toFixed(2);
                }

            }
        }


    </script>


</asp:Content>
