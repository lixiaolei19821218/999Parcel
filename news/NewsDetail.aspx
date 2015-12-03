<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NewsDetail.aspx.cs" Inherits="news_NewsDetail" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" Runat="Server">
    <title>新闻资讯 | 诚信物流-可靠,快捷,实惠</title>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <ul class="breadcrumb" style="background:none;margin-top:15px">    
            
    <div style="background-color:#fff;padding:30px;margin-top:15px; margin-bottom:15px; min-height:800px;">
       <h2><%:GetTitle() %></h2>
    <p><span style="font-size: large;"><%:GetContent() %></span></p>

    </div>   

</asp:Content>
