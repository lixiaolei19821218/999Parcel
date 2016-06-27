<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="accounts_UserCentre_Default" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>个人中心</title>
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
        }

        #sidebar ul li {
            padding: 5px;
            background: url('image/side-line.png') no-repeat 50% 100%;
        }
    </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="container" style="margin-left: -20px;">
        <div id="sidebar">
            <div class="uitopb uitopb-border" style="border-top: 1px solid #CCC; margin-top: 20px; width: 120px;">
                <h3 style="font-family: 'Microsoft YaHei';">我的账户</h3>
                <ul class="link-list">
                    <li><a href="OrderRecords.aspx" runat="server" id="total">账户金额</a></li>
                    <li><a href="Recharge.aspx" runat="server" id="rechange">我要充值</a></li>
                    <li><a href="~/cart/Paid.aspx" runat="server" id="parcel">我的订单</a></li>
                    <li><a href="" runat="server" id="addmoney">补款记录</a></li>
                    <li><a href="" runat="server" id="claim">索赔中心</a></li>
                    <li><a href="Default.aspx" class="" runat="server" id="personal">个人资料</a></li>
                    <li><a href="" runat="server" id="reset">重置密码</a></li>
                </ul>
            </div>
        </div>
        <div id="container-main" style="margin-top: 20px; width: 755px; margin-left: -20px;">
            <div class="uitopg" style="height: 365.6px;">
                <h3 class="uitopg-title mt10" style="font-family: 'Microsoft YaHei';">个人资料
                </h3>
                <div class="form">
                    <table class="table-form">
                        <tr>
                            <th>账号</th>
                            <td><%:User.UserName %></td>
                        </tr>
                        <tr>
                            <th>邮箱</th>
                            <td><%:User.Email %><a href="/index.php?c=member&a=user_profile&op=edit&field=sendmail">编辑</a>
                            </td>
                        </tr>
                        <tr>
                            <th>名</th>
                            <td><%:APUser.FirstName %></td>
                        </tr>
                        <tr>
                            <th>姓</th>
                            <td><%:APUser.LastName %></td>
                        </tr>
                        <tr>
                            <th>联系电话</th>
                            <td><%:APUser.CellPhone %><a href="/index.php?c=member&a=user_profile&op=edit&field=phone">编辑</a>
                            </td>
                        </tr>

                    </table>
                </div>
            </div>
        </div>
    </div>


</asp:Content>
