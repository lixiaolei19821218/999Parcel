<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default2" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" Runat="Server">
    <title>联系我们 | 诚信物流-可靠,快捷,实惠</title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <ul class="breadcrumb" style="background:none;margin-top:15px">
                
            </ul>
            
            
            
<div style="background-color:#fff;padding:30px 50px;margin-top:30px;margin-bottom:30px">
    <h1>联系我们</h1>
    <div style="float:left;margin:10px;padding:10px;width:460px">
        <div>
            <img src="/static/img/static/home.png" style="float:left;margin-right:5px;margin-top:-7px" />
            <div style="float:left;width:163px;margin-right:5px">官方网站<br><a href="http://www.999Parcel.com">www.999Parcel.com</a></div>
            <div style="float:left;width:140px">官方微博<br><span style="color:#428BCA">999Parcel诚信物流</span></div>
            <div style="float:left;width:163px;margin-right:5px">淘宝店<br><a href="https://shop104258668.world.taobao.com">英国诚信物流</a></div>
            <div style="float:left;width:140px">官方微信<br><span style="color:#428BCA">英国诚信物流</span></div>
            <div style="clear:both"></div>
        </div>
        
        <div style="margin-top:20px">
            <img src="/static/img/static/point.png" style="float:left;margin-right:5px;margin-top:-3px;margin-left:4px" />
            <div>仓库地址<br><span style="color:#428BCA">999 Parcel LTD, 83 Fitzwilliam Street，Sheffield    S1 4JP
</span></div>
            <div>工作时间<br><span style="color:#428BCA">周日.周一至周五 上午9点-下午5点 周六休息</span></div>
            <div style="clear:both"></div>
        </div>
    </div>
    
    <div style="float:left;margin:10px;padding:10px;width:356px">
        <img src="/static/img/static/person.png" style="float:left;margin-right:5px;margin-top:-7px" />
        <div style="float:left;width:140px">电子邮箱<br><span style="color:#428BCA">support@999Parcel.com</span></div>
        <div style="float:left;width:180px">官方QQ<br><span style="color:#428BCA">595922231 1532855482</span></div>
        <div style="float:left;width:140px">官方旺旺<br><span style="color:#428BCA">999Parcel速递</span></div>
        <div style="float:left;width:180px;margin-left:110px">客服电话<br><span style="color:#428BCA">01143273880 07946560303</span></div>
        <div style="clear:both"></div>
    </div>

    <div style="clear:both"></div>
</div>
   <script>
       $('.main-menu .contact-us').siblings().removeClass('active').end().addClass('active');
</script>

</asp:Content>

