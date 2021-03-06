﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Recharge.aspx.cs" Inherits="accounts_UserCentre_Recharge" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>账户充值</title>
    <link href="/static/css/reset.css" rel="stylesheet" type="text/css" />
    <link href="/static/css/global_v2.0.css" rel="stylesheet" type="text/css" />
    <link href="/static/css/tpl/t4/style.css" rel="stylesheet" type="text/css" />
    <link href="/static/css/artDialog/skins/default.css" rel="stylesheet" type="text/css" />
    <link href="/static/css/pager.css" rel="stylesheet" type="text/css" />
    <script src="/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <script src="/static/js/artDialog/jquery.artDialog.js" type="text/javascript"></script>
    <script src="/static/js/artDialog/iframeTools.js" type="text/javascript"></script>
    <script src="/static/js/formValidator/formValidator.min.js" type="text/javascript"></script>
    <script src="/static/js/formValidator/formValidator.regex.js" type="text/javascript"></script>
    <style type="text/css">
        #sidebar .link-list li a {
            margin: 0 auto;
            padding: 9px 10px;
            display: block;
            width: 107px;
            height: 35px;
            line-height: 18px;
            text-shadow: none;
            text-align: center;
            font-family: YouYuan;
            font-size:medium;
        }
         a{
            font-size:medium;
        }
        #welcomeDiv{
            font-size:medium;
        }
        #sidebar ul li {
            padding: 5px;
            background: url('image/side-line.png') no-repeat 50% 100%;
        }
        .table-form th {
    font-weight: normal;
    padding: 6px 0;
    width: 50px;
    text-align: right;
}
       
    </style>
    <style type="text/css">  
    .myul  
    {  
      margin:5px 5px 5px 5px;  
      padding:0px;  
    }  
    .myli  
    {   
        list-style-type:none;  
        width:150px;  
        height:150px;  
        display:inline;   
        position:relative;  
    }  
    .myimg  
    {  
        width:120px;  
        height:120px;  
    }  
    </style>  

    <link href="/scripts/uploadify/uploadify.css" type="text/css" rel="Stylesheet" />
    <script type="text/javascript" src="/scripts/jquery-1.8.0.min.js"></script>   
    <script type="text/javascript" src="/scripts/uploadify/jquery.uploadify.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#pics").hide();

            var auth = "<% = Request.Cookies[FormsAuthentication.FormsCookieName]==null ? string.Empty : Request.Cookies[FormsAuthentication.FormsCookieName].Value %>";
            var ASPSESSID = "<%= Session.SessionID %>";
            var username = "<%= Membership.GetUser().UserName %>";
            $('#fileupload').uploadify({
                'swf': '/scripts/uploadify/uploadify.swf',
                'uploader': '/accounts/UploadHandler.ashx?type=add',
                'multi': false,      //是否允许多选   
                'auto': true,       //是否允许自动上传   
                'fileTypeExts': '*.jpg;*.gif;*.png;',
                'fileTypeDesc': 'Image Files (.JPG, .GIF, .PNG, )',
                'queueID': 'queue',
                'queueSizeLimit': 300,      //同时上传数量   
                'uploadLimit': 10000,        //一次浏览器课上成总数量   
                'fileSizeLimit': '10MB',   //单个文件大小设置   
                'buttonText': '上传图片',
                'formData': { 'ASPSESSID': ASPSESSID, 'AUTHID': auth, 'Username': username },
                'onSelect': function (file) {
                    $('#fileupload').uploadifySettings('formData', { 'ASPSESSID': ASPSESSID, 'AUTHID': auth, 'Username':username });
                    alert(formDate);
                },
                'onUploadStart': function (file) {
                    //$('#fileupload').uploadifySettings('formData', { 'ASPSESSID': ASPSESSID, 'AUTHID': auth, 'Username': username });
                    $(".uploadify-button-text")[0].innerText = '上传中..';
                },
                'width': 100,//文件选择按钮大小   
                'height': 32,
                'removeCompleted': true,
                'removeTimeout': 0.1,    //上传完成后自动消失时间/秒   
                'onUploadSuccess': function (file, data, response) {                    
                    var html = "";
                    html += "    <li class=\'myli\'>";
                    html += "    <input type=\"hidden\" name=\"evidence\" value=\"" + data+ "\" />"
                    html += "    <img src=\"" + data + "\" class=\'myimg\'/>";
                    html += "    <div style=\" position:absolute; right:8px; bottom:-46px\">";
                    html += "        <img title=\"点击删除\" src=\"/static/uploadify/example/cancel.png\" style=\"cursor: pointer\" title=\"点击删除凭证\" onclick=\"delImage(\'" + data + "\');\" />";
                    html += "    </div>";
                    html += "    </li>";
                    $("#pics").append(html)
                    $(".uploadify-button-text")[0].innerText = '上传图片';
                },
                'onQueueComplete': function (file) {         //所有文件上传完成时触发此事件   
                    $("#pics").fadeIn();
                   
                }
            });
            /*
            $("#uploadify").uploadify({
                uploader: '/static/uploadify/uploadify.swf',
                script: '/accounts/UserCentre/UploadHandler.ashx?type=add',
                cancelImg: '/static/uploadify/example/cancel.png',
                //method: 'get',
                folder: 'UploadFile',
                auto: true,
                queueID: 'fileQueue-1',
                fileTypeDesc: '支持的格式：',
                fileTypeExts: '*.jpg;*.gif;*.jpeg;*.png',
                multi: false,
                fileSizeLimit: '10MB',
                queueSizeLimit: 1,
                uploadLimit: 99,
                removeTimeout: 1,
                'scriptData': { 'ASPSESSID': ASPSESSID, 'AUTHID': auth },
                'onSelect': function (file) {
                    $('#uploadify').uploadifySettings('scriptData', { 'ASPSESSID': ASPSESSID, 'AUTHID': auth });
                    alert(formDate);
                },
                'buttonText': 'Select Image',
                'onComplete': function (event, queueID, fileObj, response, data) {
                    var html = "";
                    html += "    <li class=\'myli\'>";
                    html += "    <input type=\"hidden\" name=\"evidence\" value=\"" + response + "\" />"
                    html += "    <img src=\"" + response + "\" class=\'myimg\'/>";
                    html += "    <div style=\" position:absolute; right:8px; bottom:-46px\">";
                    html += "        <img title=\"点击删除\" src=\"/static/uploadify/example/cancel.png\" style=\"cursor: pointer\" title=\"点击删除凭证\" onclick=\"delImage(\'" + response + "\');\" />";
                    html += "    </div>";
                    html += "    </li>";
                    $("#pics").append(html)
                },
                'onAllComplete': function (event, data) { //当上传队列中的所有文件都完成上传时触发  
                    //alert(data.filesUploaded + ' 个文件上传成功!');  
                    $("#pics").fadeIn();
                }
            });*/

        });
        

        function delImage(picurl) {
            jsonAjax("/accounts/UploadHandler.ashx", "type=del&picurl=" + picurl, "text", callBackTxt);
        }

        function jsonAjax(url, param, datat, callback) {
            $.ajax({
                type: "post",
                url: url,
                data: param,
                dataType: datat,
                success: callback,
                error: function () {
                    jQuery.fn.mBox({
                        message: '恢复失败'
                    });
                }
            });
        }

        function callBackTxt(data) {
            var o = data;
            if (o != "") {
                var e = $(".myli img[src='" + data + "']");
                e.each(function () {
                    $(this).parent().remove();
                })
            } else {
                alert("删除失败");
            }
        };
    </script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="container" style="margin-left: -20px;">
        <div id="sidebar">
            <div class="uitopb uitopb-border" style="border-top: 1px solid #CCC; margin-top: 20px; width: 120px;">
                <h3 style="font-family: 'Microsoft YaHei';">我的账户</h3>
                <ul class="link-list">
                    <li><a href="RechargeList.aspx" runat="server" id="total">充值明细</a></li>
                    <li><a href="Recharge.aspx" runat="server" id="rechange">我要充值</a></li>
                    <li><a href="~/cart/Paid.aspx" runat="server" id="parcel">我的订单</a></li>
                    <li><a href="Compensate.aspx" runat="server" id="addmoney">补退款记录</a></li>
                    <!--<li><a href="" runat="server" id="claim">索赔中心</a></li>-->
                    <li><a href="Default.aspx" class="" runat="server" id="personal">个人资料</a></li>
                    <!--<li><a href="" runat="server" id="reset">重置密码</a></li>-->
                </ul>
            </div>
        </div>
        <div id="container-main" style="margin-top: 20px; width: 860px; margin-left: -20px;">
    <div class="uitopg">
        <h3 class="uitopg-title mt10" style="font-family:'Microsoft YaHei'">
            <span class="rt"><a href="RechargeList.aspx" class="back">查看明细</a></span>
            账户充值
        </h3>
        <div class="form" runat="server" id="form">
            <form id="chargeForm" runat="server" method="post" autocomplete="on">
                <table class="table-form">
                    <tr>
                        <th><em>*</em>方式：</th>
                        <td>
                            <span class="f14">
                                <input type="radio" name="channelid" value="1" checked="checked" style="margin:0px;" />
                                英镑支付(转帐或存现)&nbsp;
                                <input type="radio" name="channelid" value="2"  style="margin:0px;"/>
                                人民币支付(淘宝拍)&nbsp;
                                <input type="radio" name="channelid" value="3"  style="margin:0px;"/>
                                支付宝&nbsp;                                
                            </span>
                            <span id="typeTip"></span>
                            <div id="bankpay" class="message">
                                <ul>
                                    <li>请转帐或存入英镑现金至公司帐户：</li>
                                    <li><em>·</em><span>Bank：Santander</span><span>Account：77232963</span><span>Sort Code：09-01-28</span><span>Name: Miss X Tang</span></li>
                                    <li><em>·</em>转帐请输入以下信息，并在REF处写上您的邮箱@前部份，以便查帐。例如：123@qq.com，Ref：123</li>
                                    <li><em>·</em>存现金时，请一定告诉银行职员写上您的备注REF。</li>
                                    <li><em>·</em>转帐好后请截图保存并上传给我们。存现的请保留收据，如能拍照上传最好。这样便于我们更快的审核。</li>
                                    <li><em>·</em>审核时间是工作日周一至周五10点至18点。您确认后请给我们1至2小时进行查帐并审核，超过两小时还未看到冲值余额的请联系我们客服查询。18点后冲值的，我们将会在第二个工作日为您审核。</li>
                                    <li><em>·</em>冲值一次超过1万镑的请联系我们客服，我们会按单独汇率计算。</li>
                                </ul>
                            </div>
                            <div id="taobaopay" style="display: none;">
                                <div class="message">
                                    <ul>
                                         
                                        <li><em>·</em>请按1比9.57的汇率计算人民币数额到以下地址拍下等额数量即可。如冲值100镑换算人民币是957元，请拍957件即可。拍后请立即确认付款，我们审核通过后您就可以在系统内查到您的冲值余额。</li>
                                        <li><em>·</em><a href="https://world.taobao.com/item/527163952049.htm?fromSite=main&_u=1eiv6lc21b4" target="_blank">https://world.taobao.com/item/527163952049.htm?fromSite=main&_u=1eiv6lc21b4</a></li>
                                        <li><em>·</em>审核时间是工作日周一至周五10点至18点。您确认后请给我们1至2小时进行查帐并审核，超过两小时还未看到冲值余额的请联系我们客服查询。18点后冲值的，我们将会在第二个工作日为您审核。</li>
                                        <li><em>·</em>冲值一次超过1万镑的请联系我们客服，我们会按单独汇率计算。</li>
                                    </ul>
                                </div>
                                <div class="mt10">
                                    <table class="table-form">
                                        <tr>
                                            <th style="width: 60px;"><em>*</em>旺旺：</th>
                                            <td>
                                                <input type="text" name="wangwang" id="wangwang" value="" size="20" class="input-text" /></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div id="alipay" class="message" style="display: none;">
                                <ul>
                                    <li><em>·</em>户名:严谊&nbsp&nbsp&nbsp&nbsp&nbsp账号：13568880569</li>
                                    <li><em>·</em>淘宝拍付汇率以诚信物流官网显示为准， 支付宝充值以支付宝实时汇率为准</li>
                                    <li><em>·</em>凡使用支付宝进行冲值的客户，均可享受冲100镑送3镑的优惠活动。（诚信物流折扣与冲值奖励不能同时享受）</li>
                                    <li><em>·</em>所有客户使用支付宝冲值时均无需支付手续费。</li>
                                    <li><em>·</em>诚信物流允许客户退回诚信物流余额里的款项，只需支付退款手续费3%（手续费不足3镑的按3镑收），如享受过奖励活动的，需扣除活动奖励金额。</li>
                                    <li><em>·</em>此活动的最终解释权属诚信物流公司(999 Parcel LTD)</li>
                                </ul>
                            </div>
                            <div id="worldpay" class="message" style="display: none;">
                                <ul>
                                    <li><em>·</em>所有支付最终结算货币是英镑,汇率内天随中国银行汇率变动 （We only accept £GBP.)</li>
                                    <li><em>·</em>凡使用worldpay进行冲值的客户，均可享受冲100镑送3镑的优惠活动。（诚信物流折扣与冲值奖励不能同时享受）</li>
                                    <li><em>·</em>所有客户使用worldpay冲值时均无需支付手续费。</li>
                                    <li><em>·</em>诚信物流允许客户退回诚信物流余额里的款项，只需支付退款手续费3%（手续费不足3镑的按3镑收），如享受过奖励活动的，需扣除活动奖励金额。</li>
                                    <li><em>·</em>此活动的最终解释权属诚信物流快递公司(999 Parcel LTD)</li>
                                </ul>                                
                            </div>
                        </td>
                    </tr>
                    <tr id="car_type" style="display: none;">
                        <th>卡类型：</th>
                        <td>
                            <label class="ib">
                                <input type="radio" name="paymentType" value="VISA" checked="checked" />
                                <img src="/tpl/t4/image/visa.gif" />
                            </label>
                            <label class="ib">
                                <input type="radio" name="paymentType" value="MSCD" />
                                <img src="/tpl/t4/image/mastercard.gif" />
                            </label>
                            <label class="ib">
                                <input type="radio" name="paymentType" value="VIED" />
                                <img src="/tpl/t4/image/visa_electron.gif">
                            </label>
                            <label class="ib">
                                <input type="radio" name="paymentType" value="VISD" />
                                <img src="/tpl/t4/image/visa_debit.gif">
                            </label>
                            <label class="ib">
                                <input type="radio" name="paymentType" value="MAES" />
                                <img src="/tpl/t4/image/maestro.gif">
                            </label>
                            <label class="ib">
                                <input type="radio" name="paymentType" value="JCB" />
                                <img src="/tpl/t4/image/jcb.gif" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <th><em>*</em>金额：</th>
                        <td>
                            <select class="item_detail" name="applyAmount" id="applyAmount" style="width:100px;height:23px;">
                                <option selected="selected">50</option>
                                <option>100</option>
                                <option>200</option>
                                <option>300</option>
                                <option>500</option>
                                <option>1000</option>
                            </select>
                            <!--<input type="number" name="applyAmount" id="applyAmount" value="" size="10" class="input-text" min="50" />-->£
				            <span id="mnyTip"></span>
                            <!--<div id="mnyRMB"></div>-->
                        </td>
                    </tr>
                    <tr id="image">
                        <th valign="top">凭证：</th>
                        <td>
                            <input type="file" id="fileupload" style="margin-bottom:0px;"/>
                        </td>
                    </tr>
                    <tr>
                        <th />
                        <td>
                            <div id="fileQueue-1"></div>                            
                            <div id="pics">
                                <ul class="myul">
                                </ul>
                            </div>
                        </td>
                    </tr>
                    <tr>                        
                        <td colspan="2" class="text-c">                            
                            <input type="submit" value="提交" id="dosubmit" class="btn btn-1" runat="server"/>
                        </td>
                    </tr>                            
                </table>                
            </form>
        </div>
        <span runat="server" id="message">您有正在审核的充值申请，请等待审核后再进行下次充值。<a href="RechargeList.aspx">查看</a>正在审核的申请。</span>
    </div>
            </div>
    <script type="text/javascript">
        $(function () {
            //表单提交
            $.formValidator.initConfig({
                wideWord: false,
                formID: "chargeForm",
                onSuccess: function () {
                    if ($('#type').val() == 2 && $('#ww').val() == '') {
                        $.dialog({ icon: 'warning', time: 3, content: '淘宝充值请填写旺旺号' });
                        return false;
                    } else if ($("input[name='type']:checked").val() == 5) {
                        $('#amount').val($('#applyAmount').val());
                    }
                }
            });
            $('#applyAmount').formValidator({
                onShow: "",
                onFocus: "正数，每次充值金额：0 - 5000镑"
            }).regexValidator({
                regExp: "num",
                dataType: "enum"
            });
        });
        // 切换旺旺
        
        $("input[name='channelid']").click(function () {
            var v = $(this).val();
            if (v == 1) {
                $('#taobaopay,#paypalpay,#alipay,#worldpay,#car_type').hide();
                $('#bankpay,#image').show();
            } else if (v == 2) {
                $('#bankpay,#paypalpay,#alipay,#worldpay,#car_type').hide();
                $('#taobaopay,#image').show();
            } else if (v == 3) {
                $('#bankpay,#taobaopay,#image,#paypalpay,#worldpay,#car_type').hide();
                $('#alipay,#image').show();
            }
            /*
            if (v == 5) {
                // worldpay
                $('#chargeForm').attr("action", "https://secure-test.worldpay.com/wcc/purchase");
            } else {
                $('#chargeForm').attr("action", "/index.php?c=charge&a=user_submit");
            }*/
        });
        // 金额换算
        $("#applyAmount").bind('input propertychange', function () {
            var val = parseFloat($(this).val());
            if (isNaN(val)) {
                $(this).val('');
            } else {
                var rmb = val * 9.57;
                $('#mnyRMB').text('RMB：' + rmb.toFixed(0) + '元');
            }
        });
    </script>
</asp:Content>
