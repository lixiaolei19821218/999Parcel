<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RechargeList.aspx.cs" Inherits="accounts_UserCentre_RechargeList" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>充值记录</title>
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

        .table-list th, .table-list td {
            padding: 8px 10px;
            text-align: center;
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
                    <li><a href="RechargeList.aspx" runat="server" id="total" class="on">充值明细</a></li>
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
            <h2>充值明细</h2>
            <div class="sub-nav">
                <span class="rt">账户余额<em>£<%:GetBalance() %></em></span>
                <a href="Recharge.aspx" class="back">充值</a>
            </div>
            <div class="uitopb uitopb-border mt10" style="border-top: 1px solid #CCC;">
                <div class="table-div">
                    <table class="table-list">
                        <tr>
                            <th style="font-weight:bold;">申请单号</th>
                            <th style="font-weight:bold;">方式</th>
                            <th style="font-weight:bold;">申请金额(£)</th>                           
                            <th style="font-weight:bold;">凭证</th>
                            <th style="font-weight:bold;">时间</th>
                            <th style="font-weight:bold;">审批结果</th>
                        </tr>
                        <asp:Repeater runat="server" SelectMethod="GetPageApplys" ItemType="RechargeApply">
                            <ItemTemplate>
                                <tr>
                                    <td><%#string.Format("{0:d9}", Item.Id) %></td>
                                    <td><%#Item.RechargeChannel == null ? "" : Item.RechargeChannel.Name %></td>
                                    <td><%#Item.ApplyAmount.ToString() %></td>                                    
                                    <td>
                                        <a href="<%#Item.Evidence %>" target="_blank" style="font-size:small;" title="付款凭证"><%#string.IsNullOrEmpty(Item.Evidence) ? string.Empty: "付款凭证" %></a><br />
                                    </td>
                                    <td><%#Item.Time %></td>
                                    <td><%#Item.IsApproved.HasValue ? (Item.IsApproved.Value ? "<span style=\"color:green\">审核通过</span>" : "<span style=\"color:red\">审核失败</span>") : "审核中" %></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </table>
                </div>
            </div>
            <div class="pager">
                <form runat="server">
                <% for (int i = StartPage; i < GetPageCount(); i++)
                    {
                        Response.Write(
                        string.Format("<a href='/accounts/UserCentre/RechargeList.aspx?page={0}&startpage={3}' {1} Style=\"vertical-align: middle;\">{2}</a>", i, i == CurrentPage ? "class='selected'" : "", i, StartPage));
                    }%>
                
                    <asp:ImageButton ID="btnNext" ImageUrl="/static/images/icon/next.jpg" Width="20" Height="20" runat="server" Style="vertical-align: middle;" OnClick="btnNext_Click" />
                </form>
            </div>
        </div>
    </div>
</asp:Content>
