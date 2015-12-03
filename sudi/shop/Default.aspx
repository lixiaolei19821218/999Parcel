<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default2" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" Runat="Server">
    <title>速递商城 | 诚信物流-可靠,快捷,实惠</title>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style type="text/css">
h1 {font-size:20px;margin:15px 0 20px;}
ul.steps-bar {margin-top:15px;margin-bottom:15px;padding-left:0}
ul.steps-bar li {float:left;margin:0 5px;list-style-type:none}
ul.steps-bar li a {color:#000}
</style>

<div style="background-color:#fff;padding:1px 20px 30px;margin-top:15px;margin-bottom:30px">
    <ul class="steps-bar">
        
<li><a href="/sudi/shop/">速递商城</a></li>

        <li style="float:right">
            <i class="glyphicon glyphicon-list-alt"></i>
            <a href="/sudi/shop/materials/records/">我的包装材料</a>
        </li>
        <li style="float:right">
            <i class="glyphicon glyphicon-list-alt"></i>
            <a href="/sudi/shop/order/">我的订单</a>
        </li>
        <li style="float:right">
            <i class="glyphicon glyphicon-shopping-cart"></i>
            <a href="/sudi/shop/cart/">购物车</a>
        </li>
        <div style="clear:both"></div>
    </ul>
    

<div class="panel panel-primary">
    <div class="panel-heading">
        请选择一个分类:
    </div>

    <div class="panel-body" style="padding:20px">
        <div class="row">
            
            <div class="col-md-3 col-sm-4 col-xs-6 text-center">
                <a href="/sudi/shop/category/2/">空气净化器</a> <br/>
                <a href="/sudi/shop/category/2/"><img src="/static/media/sudi2/images/blue_air_-_150x150.jpg" /></a>
            </div>
            
            <div class="col-md-3 col-sm-4 col-xs-6 text-center">
                <a href="/sudi/shop/category/3/">安全座椅</a> <br/>
                <a href="/sudi/shop/category/3/"><img src="/static/media/sudi2/images/Car_Seat_150x150.jpg" /></a>
            </div>
            
            <div class="col-md-3 col-sm-4 col-xs-6 text-center">
                <a href="/sudi/shop/category/1/">婴儿奶粉</a> <br/>
                <a href="/sudi/shop/category/1/"><img src="/static/media/sudi2/images/baby_milk.jpg" /></a>
            </div>
            
            
            <div class="col-md-3 col-sm-4 col-xs-6 text-center">
                <a href="/sudi/shop/materials/">包装材料</a> <br/>
                <a href="/sudi/shop/materials/"><img src="/static/img/sudi/box.jpg" style="width:200px"/></a>
            </div>
        </div>
    </div>
</div>


</div>

<script>
    $('.main-menu .shop').parent().siblings().removeClass('active').end().end().addClass('active');
</script>
</asp:Content>

