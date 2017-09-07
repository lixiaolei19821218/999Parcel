<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Users.aspx.cs" Inherits="Admin_Users" MasterPageFile="~/MasterPage.master" %>
<%@ Import Namespace="System.Web.Security" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>用户管理</title>
    <link href="../static/css/pager.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form runat="server" method="post" id="placeOrder" style="padding-top: 0px">
        <div class="mg1">
            
            <div class="rds2" style="background-color: #fff; padding-left: 0px; padding-right: 20px">
                <input type="text" style="margin: 10px 0; width: 30%; height: 30px" placeholder="用户名/注册邮箱" id="content" name="content"/>
                <asp:Button runat="server" cssclass="btn btn-info" style="margin-bottom: 3px; line-height: 1" text="查询 &gt;" ID="FindUser" />
            <label runat="server" id="message" />
                <a href="/admin/CheckApply.aspx" style="float: right;margin: 15px 0;">返回管理页</a>
            </div>
            
        </div>

       
        <div style="margin-top: 15px; background-color: #fff; padding: 0px">
            <fieldset runat="server" id="normalField">
                <legend>用户列表</legend>
                <table class="table table-orders" style="font-size:small;">
                    <asp:Repeater ID="Repeater1" runat="server" ItemType="System.Web.Security.MembershipUser" SelectMethod="GetPageApplys">
                        <HeaderTemplate>
                            <tr>
                                <th class="tac">用户名</th>
                                <th class="tac">注册时间</th>
                                <th class="tac">邮箱</th>
                                <th class="tac">订单数量</th>
                                <th class="tac">账户余额（£）</th>
                                <th class="tac">状态</th>                                
                                <th colspan="2"></th>
                            </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="tac"><%#Item.UserName %></td>
                                <td class="tac"><%#Item.CreationDate %></td>
                                <td class="tac"><%#Item.Email %></td>
                                <td class="tac"><%#GetUserOrderCount(Item.UserName)%></td>
                                <td class="tac"><%#GetUserBalance(Item.UserName) %></td>
                                <td class="tac"><%#Item.IsApproved ? "已激活" : "未激活" %></td>                                
                                <td colspan="2">
                                    <a href="/admin/userdetail.aspx?user=<%#Item.UserName %>">详情</a>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
                <div class="pager">
                    <label runat="server" id="userCount" style="float:right;"></label>
                    <% for (int i = 1; i <= MaxPage; i++)
                       {
                           Response.Write(
                           string.Format("<a style=\"float:left;\" href='/admin/users.aspx?page={0}' {1}>{2}</a>", i, i == CurrentPage ? "class='selected'" : "", i));
                       }%>
                </div>
            </fieldset>
            <br />           
        </div>
    </form>
</asp:Content>