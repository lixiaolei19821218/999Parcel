<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="accounts_UserCentre_Default" MasterPageFile="~/accounts/UserCentre/UserCentre.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>个人中心</title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="body" runat="Server">
    <div class="uitopg">
        <h3 class="uitopg-title mt10">个人资料
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
</asp:Content>
