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
            <div style="float:left;width:163px;margin-right:5px">官方网站<br><a href="http://www.send2china.co.uk">www.send2china.co.uk</a></div>
            <div style="float:left;width:140px">官方微博<br><span style="color:#428BCA">Send2China诚信物流</span></div>
            <div style="float:left;width:163px;margin-right:5px">淘宝店<br><a href="http://send2china.taobao.com">send2china.taobao.com</a></div>
            <div style="float:left;width:140px">官方微信<br><span style="color:#428BCA">JackieSend2China<br />Send2ChinaUK</span></div>
            <div style="clear:both"></div>
        </div>
        
        <div style="margin-top:20px">
            <img src="/static/img/static/point.png" style="float:left;margin-right:5px;margin-top:-3px;margin-left:4px" />
            <div>仓库地址<br><span style="color:#428BCA">JRD Ltd, Unit 6, Martlets Trading Estate, 
    Martlets Way, Worthing, BN12 4HF</span></div>
            <div>工作时间<br><span style="color:#428BCA">上午9点-下午6点（周末：上午11点-下午3点）</span></div>
            <div style="clear:both"></div>
        </div>
    </div>
    
    <div style="float:left;margin:10px;padding:10px;width:356px">
        <img src="/static/img/static/person.png" style="float:left;margin-right:5px;margin-top:-7px" />
        <div style="float:left;width:140px">电子邮箱<br><span style="color:#428BCA">enquiries@send2china.co.uk</span></div>
        <div style="float:left;width:140px">官方QQ<br><span style="color:#428BCA">800080639</span></div>
        <div style="float:left;width:140px">官方旺旺<br><span style="color:#428BCA">Send2china速递</span></div>
        <div style="float:left;width:140px;margin-left:110px">客服电话<br><span style="color:#428BCA">019-0386-3220</span></div>
        <div style="clear:both"></div>
    </div>

    <div style="clear:both"></div>
</div>
   <script>
       $('.main-menu .contact-us').siblings().removeClass('active').end().addClass('active');
</script>

</asp:Content>

