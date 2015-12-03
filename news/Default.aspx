<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default2" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" Runat="Server">
    <title>新闻资讯 | 诚信物流-可靠,快捷,实惠</title>
    <link href="../static/css/pager.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <ul class="breadcrumb" style="background:none;margin-top:15px">
                
    <li><a href="">新闻资讯</a></li>

            </ul>
            
            
            
    <div style="background-color:#fff;padding:30px;margin-top:15px; min-height:800px;">
        <asp:Repeater runat="server" ItemType="News" SelectMethod="GetPageNews">
            <ItemTemplate>
                <a href="/news/newsdetail.aspx?id=<%#Item.Id %>" class="mg2 bg2" style="background-position: -356px -4px; background-repeat: no-repeat">
                    <span class="clrb5 bold"><%#Item.PulishTime %></span>&nbsp;<span class="clrb4"><%#Item.Title %></span>
                </a>
            </ItemTemplate>
        </asp:Repeater>
    </div>
     <div class="pager">
            <% for (int i = 1; i <= MaxPage; i++)
               {
                   Response.Write(
                   string.Format("<a href='/News/Default.aspx?page={0}' {1}>{2}</a>", i, i == CurrentPage ? "class='selected'" : "", i));
               }%>
        </div>
    <script>
        $('.main-menu .our-services').parent().siblings().removeClass('active').end().end().addClass('active');
</script>

</asp:Content>

