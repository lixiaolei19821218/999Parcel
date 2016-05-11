<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TraceEdit.aspx.cs" Inherits="Admin_TraceEdit" MasterPageFile="~/MasterPage.master"%>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>运单编辑 | 诚信物流-可靠,快捷,实惠</title>
    <style type="text/css">
        .track-list {
            font: 12px/150% Arial,Verdana,"\5b8b\4f53";
            color: #666;
        }

        li {
            margin: 10px;
        }

        .time {
            margin-right: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="login">
		<div class="login-grids">
			<div class="col-md-6 log">
					 <h3>编辑运单</h3>					 
					 <form runat="server">
						 <h5>添加运单:</h5>	
						 <input type="text" value="">
                         <input type="submit" value="添加">	
                         <h5>已添加运单:</h5>
                         <asp:ListBox ID="ListBox1" runat="server" Height="300px" Width="300px"></asp:ListBox>
						 <h5 style="margin-top:30px;">查找运单:</h5>
						 <input type="password" value="">					
						 <input type="submit" value="查找">						  
					 </form>
					
			</div>
			<div class="col-md-6 login-right">
                <h3>运单轨迹</h3>
					<div class="track-list">
                    <ul>

                    <li class="first"><i class="node-icon"></i><span class="time">2016-05-10 16:32:13</span><span class="txt">感谢您在京东购物，欢迎您再次光临！</span></li><li><i class="node-icon"></i><span class="time">2016-05-10 15:45:19</span><span class="txt">京东配送员【徐思明】已出发，联系电话【15208429259，感谢您的耐心等待，参加评价还能赢取京豆呦】</span></li><li><i class="node-icon"></i><span class="time">2016-05-10 15:30:37</span><span class="txt">您的订单在京东【成都中和站】验货完成，正在分配配送员</span></li><li><i class="node-icon"></i><span class="time">2016-05-10 10:59:05</span><span class="txt">您的订单在京东【成都郫县分拣中心】发货完成，准备送往京东【成都中和站】</span></li><li><i class="node-icon"></i><span class="time">2016-05-10 10:57:45</span><span class="txt">您的订单在京东【成都郫县分拣中心】分拣完成</span></li><li><i class="node-icon"></i><span class="time">2016-05-10 10:04:16</span><span class="txt">您的订单在京东【成都郫县分拣中心】收货完成</span></li><li><i class="node-icon"></i><span class="time">2016-05-08 23:09:33</span><span class="txt">您的订单在京东【广州博展分拣中心】发货完成，准备送往京东【成都郫县分拣中心】</span></li><li><i class="node-icon"></i><span class="time">2016-05-08 21:48:10</span><span class="txt">您的订单在京东【广州太和分拨中心】发货完成，准备送往京东【广州博展分拣中心】</span></li><li><i class="node-icon"></i><span class="time">2016-05-08 20:52:53</span><span class="txt">您的订单在京东【广州太和分拨中心】分拣完成</span></li><li><i class="node-icon"></i><span class="time">2016-05-08 20:15:12</span><span class="txt">您的订单在京东【广州太和分拨中心】收货完成</span></li><li><i class="node-icon"></i><span class="time">2016-05-08 18:39:45</span><span class="txt">配送司机收箱</span></li><li><i class="node-icon"></i><span class="time">2016-05-08 17:17:16</span><span class="txt">您的订单在京东【同德围站】装箱完成</span></li><li><i class="node-icon"></i><span class="time">2016-05-08 17:14:58</span><span class="txt">您的订单已由【同德围站】接货完成</span></li><li><i class="node-icon"></i><span class="time">2016-05-08 17:07:35</span><span class="txt">您的订单由第三方卖家拣货完毕，待出库交付京东快递，运单号为vc26905193895</span></li><li><i class="node-icon"></i><span class="time">2016-05-08 17:02:23</span><span class="txt">第三方卖家已经开始拣货，订单不能修改</span></li><li><i class="node-icon"></i><span class="time">2016-05-08 10:59:07</span><span class="txt">您的订单已进入第三方卖家库房，准备出库</span></li><li><i class="node-icon"></i><span class="time">2016-05-08 10:58:39</span><span class="txt">您提交了订单，请等待第三方卖家系统确认</span></li></ul>
                </div>
					<h3>添加轨迹</h3>
					<input type="text" value="">
					<input type="submit" value="提交">	
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
</asp:Content>