<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default2" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" Runat="Server">
    <title>国际快递 | 诚信物流-可靠,快捷,实惠</title>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <ul class="breadcrumb" style="background:none;margin-top:15px">
                
            </ul>
            
            
            
<div style="background-color:#fff;padding:30px 50px;margin-top:30px;margin-bottom:30px">
    <h1>国际快递</h1>
    
    <p>诚信物流为您提供从英国到中国大陆，台湾，香港和澳门的国际包裹快递服务。我们合作的国际运营商有比利时邮政，英国皇家邮政Parcelforce和Fedex。</p>
    

    <div style="background-color:#EBF4FA;padding:20px 50px">
        <a href="/our-services/zy/bp/" style="margin-right:20px"><img src="/static/img/static/bp1.png" /></a>
        <a href="/our-services/zy/pfg/" style="margin-right:20px"><img src="/static/img/static/pfg1.png" /></a>
        <a href="/our-services/zy/pfe/"><img src="/static/img/static/pfe1.png" /></a>
        <div style="clear:both"></div>
    </div>
    
    <div style="margin-top:10px">
        <img src="/static/img/static/zy.png" style="width:100%" />
    </div>
</div>
    <script>
        $('.main-menu .zy').parent().siblings().removeClass('active').end().end().addClass('active');
</script>
</asp:Content>

