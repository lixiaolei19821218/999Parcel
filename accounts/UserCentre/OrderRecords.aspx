<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderRecords.aspx.cs" Inherits="accounts_UserCentre_OrderRecords" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>账号消费记录</title>
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

        #sidebar ul li {
            padding: 5px;
            background: url('image/side-line.png') no-repeat 50% 100%;
        }
         a{
            font-size:medium;
        }
        #welcomeDiv{
            font-size:medium;
        }
         </style>
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
                    <li><a href="" runat="server" id="claim">索赔中心</a></li>-->
                    <li><a href="Default.aspx" class="" runat="server" id="personal">个人资料</a></li>
                    <!--<li><a href="" runat="server" id="reset">重置密码</a></li>-->
                </ul>
            </div>
        </div><div id="container-main" style="margin-top: 20px; width: 860px; margin-left: -20px;">
    <h2>账户金额</h2>
    <div class="sub-nav">
        <a href="Recharge.aspx" class="add">我要充值</a>
        <a href="RechargeList.aspx" class="pay">充值明细</a>
    </div>
    <div class="uitopb uitopb-border mt10">
        <div class="table-div">
            <table class="table-list">
                <tr>
                    <th>类型</th>
                    <th>金额(£)</th>
                    <th>余额(£)</th>
                    <th>时间</th>
                </tr>
                <tr>
                    <td colspan="4">暂无数据</td>
                </tr>
            </table>
        </div>
    </div>
    <div class="pager"></div>
            </div>
</asp:Content>
