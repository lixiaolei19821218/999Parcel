<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default3.aspx.cs" Inherits="Default3" MasterPageFile="~/MasterPage.master" %>


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
           font-family:'Microsoft YaHei UI';
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
										
						<div style="width:640px;height:520px;border:solid #C34C21 1px;">
                            <div>
                                <div style="width:50%;padding:20px;float:left;">
                                    <span>发件地</span>
                                    <select style="margin: 0; width: 50%">
                                        <option>英国</option>
                                    </select>
                                </div>
                                <div style="width:50%;padding:20px;float:left;">
                                    <span class="tal clrb3 bold">收件地</span>
                                    <select style="margin: 0; width: 50%" name="to_area">
                                        <option value="CN">中国大陆</option>
                                        <!--<option value="HK">中国香港</option>
                                            <option value="MO">中国澳门</option>
                                            <option value="TW">台湾</option>-->
                                    </select>
                                </div>
                            </div>                         
                             <div style="width:100%;padding:10px;float:left;color:white;background-color:#C34C21">
                                 收件人<span>1</span>
                                 <button style="float:right;border:0px;color:white;background-color:transparent;height:20px;width:20px;" title="减少收件人">-</button>
                                 <button style="float:right;border:0px;color:white;background-color:transparent;height:20px;width:20px;font-size:large;" title="添加收件人">+</button>
                                 
                             </div>  
                            <div style="width:100%;padding:10px;float:left;">
                            <div style="float:left;">
                                <div style="padding:10px;float:left;"><input placeholder="重量(KG)" style="float:left;width:100px;margin:5px;padding:5px;" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = '重量(KG)';}"/></div>
                                
                            </div>
                            <div style="float:left;">
                                <div style="padding:10px;float:left;"><input placeholder="宽(CM)" style="float:left;width:100px;margin:5px;padding:5px;"/></div>
                                
                            </div>
                            <div style="float:left;">
                                <div style="padding:10px;float:left;"><input placeholder="宽(CM)" style="float:left;width:100px;margin:5px;padding:5px;"/></div>
                                
                            </div>
                            <div style="float:left;">
                                <div style="padding:10px;float:left;"><input type="text" placeholder="高(CM)" style="float:left;width:100px;margin:5px;padding:5px;"/></div>
                                
                            </div>
                            
                            <button style="float:right;border:0px;color:#C34C21;background-color:transparent;height:20px;width:20px;padding:20px;outline:none;" title="减少收件人">-</button>
                                 <button style="float:right;border:0px;color:#C34C21;background-color:transparent;height:20px;width:20px;font-size:large;padding:20px;outline:none;" title="添加收件人">+</button>
                              </div>
                            
						</div>
						
						<div class="rd-mre">
							<a href="single.html" class="hvr-bounce-to-bottom quod">立即下单</a>
						</div>
					</div>
					<div class="blog-left-grid">										
						<a href="single.html"><img src="static/img/mall_640_426.png" alt=" " class="img-responsive" /></a>
						<p class="para"> 诚信商场提供UK到China的海淘服务。保证正品，物美价廉。总部设在英国的谢菲尔德，配有大面积的仓贮仓库，可容纳大批量货物仓储。我们的业务覆 盖全英国，主营英国直邮中国的货物运输和海淘的代购及转运业务。 此外，我们对于婴幼儿食品的直邮空运，代购，转运都可以提供免费的咨询服务。</p>
						<div class="rd-mre">
							<a href="single.html" class="hvr-bounce-to-bottom quod">开始购物</a>
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
										<a href="images/7-.jpg" class="b-link-stripe b-animate-go   swipebox"  title="">
											<img src="static/img/baby_milk.jpg" alt=" " class="img-responsive" />
										</a>
									  </div>
									  <div class="tab_list1">
										<a href="#">婴儿奶粉</a>
										<p>￡10起售 <span>爱他美，牛栏。UK超市购买，可提供原始发票。</span></p>
									  </div>
									  <div class="clearfix"> </div>
									</div>
									<div class="facts">
									   <div class="tab_list">
										<a href="images/8-.jpg" class="b-link-stripe b-animate-go   swipebox"  title="">
											<img src="static/img/Car_Seat.jpg" alt=" " class="img-responsive" />
										</a>
									  </div>
									  <div class="tab_list1">
										<a href="#" style="font-family:'Microsoft YaHei UI'" >婴儿安全座椅</a>
										<p>￡200<span style="font-family:'Microsoft YaHei UI'">安全可靠，做中国好司机，做中国好父母。</span></p>
									  </div>
									  <div class="clearfix"> </div>
									</div>
									<div class="facts">
									   <div class="tab_list">
										<a href="images/9-.jpg" class="b-link-stripe b-animate-go   swipebox"  title="">
											<img src="static/img/box.jpg" alt=" " class="img-responsive" />
										</a>
									  </div>
									  <div class="tab_list1">
										<a href="#">打包服务</a>
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
						<form>
							<input type="text" value="订单号" onFocus="this.value = '';" onBlur="if (this.value == '') {this.value = '订单号';}" required=""/>
							<input type="submit" value="查询"/>
						</form>
					</div>
					<div class="four-fig">
						<div class="four-fig1">
							<a href="images/11-.jpg" class="b-link-stripe b-animate-go   swipebox"  title="">
								<img src="/static/img/adv/adv1_300_200.png" class="img-responsive" alt=" " />
							</a>
						</div>
						<div class="four-fig1">
							<a href="images/14-.jpg" class="b-link-stripe b-animate-go   swipebox"  title="">
								<img src="/static/img/adv/adv2_300_200.png" class="img-responsive" alt=" " />
							</a>
						</div>
						<div class="four-fig1">
							<a href="images/10-.jpg" class="b-link-stripe b-animate-go   swipebox"  title="">
								<img src="/static/img/adv/adv3_300_200.png" class="img-responsive" alt=" " />
							</a>
						</div>
						<div class="four-fig1">
							<a href="images/8-.jpg" class="b-link-stripe b-animate-go   swipebox"  title="">
								<img src="/static/img/adv/adv1_300_200.png" class="img-responsive" alt=" " />
							</a>
						</div>
						<div class="clearfix"> </div>
					</div>
					<div class="pgs">
						<h3>新闻资讯</h3>
						<ul>							
							<li><a href="#">针对包税服务的服务调整通知</a></li>
							<li><a href="#">2016年复活节放假通知</a></li>
							<li><a href="#">英卖通服务上线</a></li>
							<li><a href="#">英国皇家邮政小包裹专线， 2公斤低至12.5镑</a></li>
							<li><a href="#">bpost 价格上调通知</a></li>
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

<!-- //header-bottom -->
</asp:Content>
