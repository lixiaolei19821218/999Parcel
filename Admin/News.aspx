<%@ Page Language="C#" AutoEventWireup="true" CodeFile="News.aspx.cs" Inherits="Admin_News" MasterPageFile="~/Admin/Admin.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>新闻资讯</title>
     
    
    <link rel="stylesheet" href="/static/css/guofan.css"/>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="body" runat="Server">
    <form runat="server">
        
            <div>

                <asp:Button runat="server" CssClass="btn btn-info" Style="margin-bottom: 30px; width:100px; background-color:yellowgreen;" Text="添加新闻" OnClick="AddNews_Click" ID="AddNews" />
            </div>
        <hr />
        
        <div class="table-div">
            <table class="table table-orders" style="width:100%; border:0px;">
                <asp:Repeater runat="server" SelectMethod="GetPageNews" ItemType="News">
                    <ItemTemplate>
                        <tr>      
                            <td align="left"><span class="clrb5 bold"><%#Item.PulishTime %></span>&nbsp;<span class="clrb4"><%#Item.Title %></span></td>                            
                            <td align="right">
                                <asp:linkbutton ID="ButtonEdit" runat="server" Text="编辑" data-id="<%#Item.Id %>" OnClick="ButtonEdit_Click" />
                                <asp:linkButton ID="ButtonDelete" runat="server" Text="删除"  data-id="<%#Item.Id %>" OnClick="ButtonDelete_Click" />
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </div>

        <div class="pager">
            <% for (int i = 1; i <= MaxPage; i++)
               {
                   Response.Write(
                   string.Format("<a href='/Admin/News.aspx?page={0}' {1}>{2}</a>", i, i == CurrentPage ? "class='selected'" : "", i));
               }%>
        </div>
    </form>
</asp:Content>
