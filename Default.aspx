<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default" EnableEventValidation="false" MasterPageFile="~/MasterPage.master" %>


<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>首页 | 诚信物流-可靠,快捷,实惠</title>
    <style type="text/css">
        .loginText {
            font-size:12px;
            margin-right:5px;
        }
            .loginText td {
                margin: 5px;
            }
        .tab_list1 a, .tab_list1 p, .tab_list1 p span {
            font-family:'Microsoft YaHei UI';
        }
        p {
            font-family: 'Microsoft YaHei UI';
        }

        .rd-mre input {
            padding: 10px 30px;
            color: #fff;
            background: url(../images/img-sp.png) no-repeat 61px -191px #c34c21;
            display: block;
            width: 130px;
            text-decoration: none;
            font-size: 14px;
            font-family: LobsterTwo-Regular;
        }

        input.quod:before {
            background: url(../images/img-sp.png) no-repeat 61px -191px #F04709;
            display: block;
        }
    </style> 
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <!-- header-bottom -->

		<div class="header-bottom-top">
			<ul>
				
			</ul>
		</div>
		<div class="clearfix"> </div>
<!-- banner -->
		
<!-- Slider-starts-Here -->				
			<!--//End-slider-script -->            
            <div id="banners" class="carousel slide" data-ride="carousel" data-interval="5000">
                <!-- Wrapper for slides -->
                <div class="carousel-inner">
                    <div class="item active">
                        <img src="/static/img/banner/sudi1.jpg" />
                    </div>
                    <div class="item">
                        <img src="/static/img/banner/sudi2.jpg" />
                    </div>
                    <div class="item">
                        <img src="/static/img/banner/sudi3.jpg" />
                    </div>
                </div>
                <!-- Controls -->
                <a class="left carousel-control" href="#banners" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left"></span>
                </a>
                <a class="right carousel-control" href="#banners" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right"></span>
                </a>                
            </div> 
		
<!-- //banner -->

<!-- blog -->
			<div class="blog">
				<div class="blog-left">
					<div class="blog-left-grid">
                        <form runat="server">
                            <div class="pane1 mg1">
                            <div style="width: 100px; height: 44px; background-color: #C34C21; color: white; text-align: center; line-height: 44px;">
                                快速询价
                            </div>
                            <div class="rds2" style="text-align: center; border: 1px solid #C34C21; height: 500px;overflow:auto;">
                                <form id="Form1" method="post" style="margin: 0">
                                    <input type='hidden' name='csrfmiddlewaretoken' value='8aqZpoXHNqSZ280pPAWg7NUC4SD31C5B' />
                                    <div class="row" style="margin: 0px;">
                                        <div class="col-xs-6" style="width: 50%; padding: 20px; float: left;">
                                            <span class="tal clrb3 bold">发件地</span>
                                            <select style="margin: 0; width: 50%">
                                                <option>英国</option>
                                            </select>
                                        </div>
                                        <div class="col-xs-6" style="width: 50%; padding: 20px; float: left;">
                                            <span class="tal clrb3 bold">收件地</span>
                                            <select style="margin: 0; width: 50%" name="to_area">
                                                <option value="CN">中国大陆</option>
                                                <!--<option value="HK">中国香港</option>
                                            <option value="MO">中国澳门</option>
                                            <option value="TW">台湾</option>-->
                                            </select>
                                        </div>
                                    </div>
                                    <div style="align-content: flex-start">
                                        <asp:Label ID="LabelError" runat="server" Text="Label" Visible="false" ForeColor="Red"></asp:Label>
                                    </div>
                                    <div class="formset formset_1">
                                        <div class="bg4 addr clrb3 bold tal" style="width: 100%; padding: 10px; float: left; color: white; background-color: #C34C21">
                                            收件人<span class="addr_num">1</span>
                                            <button type="button" class="del_addr btn1 fr" title="删除收件人" style="float: right; border: 0px; color: white; background-color: transparent; height: 20px; width: 20px; outline: none">-</button>
                                            <button type="button" class="add_addr btn1 fr" title="添加收件人" style="float: right; border: 0px; color: white; background-color: transparent; height: 20px; width: 20px; font-size: large; outline: none;">+</button>
                                        </div>
                                        <div class="pkt-err"></div>
                                        <div class="packet">
                                            
                                            <div style="width: 85%; padding: 0px; float: left;">
                                                <div class="row" style="display: inline-block; width: 100%; margin-top: -3px" title="重量不能超过30kg，长宽高分别不能大于105cm，长×宽×高÷5000不能大于30。">
                                                    <div class="attr col-xs-3 input1" style="padding: 10px; float: left;">
                                                        <input id="id_addr_0-0-weight" name="addr_0-0-weight" placeholder="重量" type="number" max="30" min="1" style="width: 80px;" required="required" />(kg)
                                                    </div>
                                                    <div class="attr col-xs-3 input1" style="padding: 10px; float: left;">
                                                        <input id="id_addr_0-0-length" name="addr_0-0-length" placeholder="长度" type="number" max="105" min="1" style="width: 80px;" required="required" />(cm)
                                                    </div>
                                                    <div class="attr col-xs-3 input1" style="padding: 10px; float: left;">
                                                        <input id="id_addr_0-0-width" name="addr_0-0-width" placeholder="宽度" type="number" max="105" min="1" style="width: 80px;" required="required" />(cm)
                                                    </div>
                                                    <div class="attr col-xs-3 input1" style="padding: 10px; float: left;">
                                                        <input id="id_addr_0-0-height" name="addr_0-0-height" placeholder="高度" type="number" max="105" min="1" style="width: 80px;" required="required" />(cm)
                                                    </div>
                                                </div>                                                
                                            </div>
                                            <div style="float: left; width: 15%">
                                                <button type="button" class="del_pkt btn2 fr" title="删除包裹" style="float: right; border: 0px; color: #C34C21; background-color: transparent; height: 20px; width: 20px; padding: 10px 20px; outline: none;">-</button>
                                                <button type="button" class="add_pkt btn2 fr" title="添加包裹" style="float: right; border: 0px; color: #C34C21; background-color: transparent; height: 20px; width: 20px; padding: 10px 20px; outline: none;">+</button>
                                            </div>
                                            <div class="cb"></div>
                                        </div>
                                        <input id="id_addr_0-TOTAL_FORMS" name="addr_0-TOTAL_FORMS" type="hidden" value="1" /><input id="id_addr_0-INITIAL_FORMS" name="addr_0-INITIAL_FORMS" type="hidden" value="0" /><input id="id_addr_0-MAX_NUM_FORMS" name="addr_0-MAX_NUM_FORMS" type="hidden" value="100" />
                                        <script>
                                            $(function () { add_address('addr_0', $('.formset_1')); });
                                        </script>
                                    </div>                                    
                                </form>
                            </div>
                            <div class="rd-mre">
                                <asp:Button runat="server" Text="立即下单" CssClass="hvr-bounce-to-bottom quod" ID="btnSubmit" OnClick="btnSubmit_Click" BorderStyle="None" />
                            </div>
                    </div>						
						</form>
					</div>
					<div class="blog-left-grid">										
						<a href="single.html"><img src="static/img/mall_668_426.png" alt=" " class="img-responsive" /></a>
						<p class="para"> 诚信商场提供UK到China的海淘服务。保证正品，物美价廉。总部设在英国的谢菲尔德，配有大面积的仓贮仓库，可容纳大批量货物仓储。我们的业务覆 盖全英国，主营英国直邮中国的货物运输和海淘的代购及转运业务。 此外，我们对于婴幼儿食品的直邮空运，代购，转运都可以提供免费的咨询服务。</p>
						<div class="rd-mre">
							<a class="hvr-bounce-to-bottom quod">开始购物</a>
						</div>
					</div>
				</div>
				<div class="blog-right">
					<div class="sap_tabs">	
					<div id="horizontalTab" style="display: block; width: 100%; margin: 0px;">
						  <ul class="resp-tabs-list">
							  <li class="resp-tab-item grid1" aria-controls="tab_item-0" role="tab"><span>热销产品</span></li>
							  
						  </ul>				  	 
							<div class="resp-tabs-container">
								<div class="tab-1 resp-tab-content" aria-labelledby="tab_item-0">
									<div class="facts">
									  <div class="tab_list">
										<a title="">
											<img src="static/img/baby_milk.jpg" alt=" " class="img-responsive" />
										</a>
									  </div>
									  <div class="tab_list1">
										<a>婴儿奶粉</a>
										<p>￡10起售 <span>爱他美，牛栏。UK超市购买，可提供原始发票。</span></p>
									  </div>
									  <div class="clearfix"> </div>
									</div>
									<div class="facts">
									   <div class="tab_list">
										<a title="">
											<img src="static/img/Car_Seat.jpg" alt=" " class="img-responsive" />
										</a>
									  </div>
									  <div class="tab_list1">
										<a style="font-family:'Microsoft YaHei UI'" >婴儿安全座椅</a>
										<p>￡200<span style="font-family:'Microsoft YaHei UI'">安全可靠，做中国好司机，做中国好父母。</span></p>
									  </div>
									  <div class="clearfix"> </div>
									</div>
									<div class="facts">
									   <div class="tab_list">
										<a title="">
											<img src="static/img/box.jpg" alt=" " class="img-responsive" />
										</a>
									  </div>
									  <div class="tab_list1">
										<a>打包服务</a>
										<p>低至￡2每箱<span>诚信物流提供贴心的打包加固服务。</span></p>
									  </div>
									  <div class="clearfix"> </div>
									</div>
									
								</div>
								
							</div>
						 <script src="js/easyResponsiveTabs.js" type="text/javascript"></script>
							<script type="text/javascript">
							    $(document).ready(function () {
							        $('#horizontalTab').easyResponsiveTabs({
							            type: 'default', //Types: default, vertical, accordion           
							            width: 'auto', //auto or any width like 600px
							            fit: true   // 100% fit in a container
							        });
							    });
							   </script>
						<link rel="stylesheet" href="css/swipebox.css">
						<script src="js/jquery.swipebox.min.js"></script> 
							<script type="text/javascript">
							    jQuery(function ($) {
							        $(".swipebox").swipebox();
							    });
							</script>
					</div>
					</div>
					<div class="newsletter">
						<h3>订单跟踪</h3>
						<form method="post" action="./Default.aspx">
							<input type="text" value="订单号" name="txtTraceNumber" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = '订单号';}" required="required"/>
							<input type="submit" value="查询" name="btnQuery"/>
						</form>
					</div>
					<div class="four-fig">
						<div class="four-fig1">
							<a title="">
								<img src="/static/img/adv/adv1_300_200.png" class="img-responsive" alt=" " />
							</a>
						</div>
						<div class="four-fig1">
							<a title="">
								<img src="/static/img/adv/adv2_300_200.png" class="img-responsive" alt=" " />
							</a>
						</div>
						<div class="four-fig1">
							<a title="">
								<img src="/static/img/adv/adv3_300_200.png" class="img-responsive" alt=" " />
							</a>
						</div>
						<div class="four-fig1">
							<a title="">
								<img src="/static/img/adv/adv1_300_200.png" class="img-responsive" alt=" " />
							</a>
						</div>
						<div class="clearfix"> </div>
					</div>
					<div class="pgs">
						<h3>新闻资讯</h3>
						<ul>					
                            <asp:Repeater runat="server" ItemType="News" SelectMethod="GetNews" >
                                <ItemTemplate>
                                        
                                    <li><a href="/news/newsdetail.aspx?id=<%#Item.Id %>"><%#Item.Title %></a></li>
                                    </ItemTemplate>
                            </asp:Repeater>		
							
						</ul>
					</div>
				</div>
				<div class="clearfix"> </div>
			</div>
<!-- //blog -->
	<!-- banner-bottom -->
			<div class="banner-bottom">
				<ul id="flexiselDemo1">			
					<li>
						<div class="banner-bottom-grid">
							<img src="static/img/999parcel_400_300.png" alt=" " class="img-responsive" />
							<p>诚信物流 (999Parcel)是一家英国独资综合性质的国际物流公司。总部设在英国的谢菲尔德，配有大面积的仓贮仓库，可容纳大批量货物仓储。我们的业务覆 盖全英国，主营英国直邮中国的货物运输和海淘的代购及转运业务。 此外，我们对于婴幼儿食品的直邮空运，代购，转运都可以提供免费的咨询服务。</p>
							
						</div>
					</li>
					<li>
						<div class="banner-bottom-grid">
							<img src="static/img/partners_400_300.png" alt=" " class="img-responsive" />
							<p>我们的合作伙伴包括Parcel Force, Bpost, UK Mail, DPD, EMS等国际知名物流公司。同时提供PayPal, 支付宝等多种支付方式，满足您的需求。我们的合作伙伴包括Parcel Force, Bpost, UK Mail, DPD, EMS等国际知名物流公司。同时提供PayPal, 支付宝等多种支付方式，满足您的需求。</p>
							
						</div>
					</li>
					<li>
						<div class="banner-bottom-grid">
							<img src="static/img/SheffieldPickup_400_300.png" alt=" " class="img-responsive" />
							<p>诚信物流提供优质的谢菲尔德取件，打包，加固服务。只要一个电话，轻松搞定。诚信物流提供优质的谢菲尔德取件，打包，加固服务。只要一个电话，轻松搞定。诚信物流提供优质的谢菲尔德取件，打包，加固服务。只要一个电话，轻松搞定。</p>
							
						</div>
					</li>
				</ul>
				<script type="text/javascript">
				    $(window).load(function () {
				        $("#flexiselDemo1").flexisel({
				            visibleItems: 3,
				            animationSpeed: 1000,
				            autoPlay: false,
				            autoPlaySpeed: 3000,
				            pauseOnHover: true,
				            enableResponsiveBreakpoints: true,
				            responsiveBreakpoints: {
				                portrait: {
				                    changePoint: 480,
				                    visibleItems: 1
				                },
				                landscape: {
				                    changePoint: 640,
				                    visibleItems: 2
				                },
				                tablet: {
				                    changePoint: 768,
				                    visibleItems: 3
				                }
				            }
				        });

				    });
					</script>
					<script type="text/javascript" src="js/jquery.flexisel.js"></script>
			</div>
<!-- //banner-bottom -->
    <script src="/static/js/jquery.formset2.js"></script>
    <script src="/static/js/home.js"></script>
<!-- //header-bottom -->
</asp:Content>
