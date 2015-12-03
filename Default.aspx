<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default2" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" Runat="Server">
    <title>首页 | 诚信物流-可靠,快捷,实惠</title>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/jquery") %>
    <script src="/static/bootstrap3/js/jquery-1.11.1.min.js"></script>   
    <script type="text/javascript">
        function validateSize() {
            var rCount = $("div[class='formset formset_1']").length;
            for (var i = 0; i < rCount; i++)
            {
                var selector = "input[name='addr_" + i + "-TOTAL_FORMS']";
                var pCount = $(selector)[0].value;
                for (var j = 0; j < pCount; j++)
                {
                    var length = $("input[name='addr_" + i + "-" + j + "-length']")[0].value;
                    var width = $("input[name='addr_" + i + "-" + j + "-width']")[0].value;
                    var height = $("input[name='addr_" + i + "-" + j + "-height']")[0].value;
                    if (length * width * height / 5000 > 30) {
                        $("input[name='addr_" + i + "-" + j + "-height']")[0].setCustomValidity("体积重量不能大于30");
                    }
                    else {
                        $("input[name='addr_" + i + "-" + j + "-height']")[0].setCustomValidity("");
                        break;
                    }                    
                }
            }            
        }
    </script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="row" style="position: relative">
                <div style="position: absolute; right: -125px; top: 160px">
                    <img src="/static/img/kefu.png" /></div>

                <div class="col-sm-8 col-xs-12" style="padding-right: 5px">

                    <!-- banners -->
                    <div class="mg1">
                        <div id="banners" class="carousel slide" data-ride="carousel" data-interval="5000">


                            <!-- Wrapper for slides -->
                            <div class="carousel-inner">
                                <div class="item active">
                                    <img src="/static/img/banner/bpost_banner_new.png" />
                                </div>
                                <div class="item">
                                    <a href="/sudi/shop/">
                                        <img src="/static/img/banner/sudi_shop3.jpg" /></a>
                                </div>
                                <div class="item">
                                    <img src="/static/img/banner/sudi.png" />
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
                    </div>

                    <!-- quote parcel price -->
                    <div class="pane1 mg1">


                        <div class="bg1 rds1 clrw1 sz16 bold" style="height: 38px; background-position: 0 -43px; background-repeat: repeat-x; padding: 10px 20px">
                            快速询价
                        </div>

                        <div class="rds2" style="background-color: #F2F8FC; text-align: center; border-left: 1px solid #0075C2; border-right: 1px solid #0075C2; border-bottom: 1px solid #0075C2; padding: 20px 15px 0">
                            <form method="post" style="margin: 0" runat="server">
                                <input type='hidden' name='csrfmiddlewaretoken' value='8aqZpoXHNqSZ280pPAWg7NUC4SD31C5B' />

                                <div class="row">
                                    <div class="col-xs-6">
                                        <span class="tal clrb3 bold">发件地</span>
                                        <select style="margin: 0; width: 50%">
                                            <option>英国</option>
                                        </select>
                                    </div>
                                    <div class="col-xs-6">
                                        <span class="tal clrb3 bold">收件地</span>
                                        <select style="margin: 0; width: 50%" name="to_area">
                                            <option value="CN">中国大陆</option>
                                            <option value="HK">中国香港</option>
                                            <option value="MO">中国澳门</option>
                                            <option value="TW">台湾</option>
                                        </select>
                                    </div>
                                </div>

                                <div style="align-content:flex-start">
                                <asp:Label ID="LabelError" runat="server" Text="Label" Visible="false" ForeColor="Red"></asp:Label>
                                    </div>
                                <div class="formset formset_1">
                                    <div class="bg4 addr clrb3 bold tal" style="margin: 20px -15px 0; padding: 7px 15px">
                                        收件人
                    <span class="addr_num">1</span>
                                        <button type="button" class="del_addr btn1 fr" title="删除收件人" style="margin-left: 7px">-</button>
                                        <button type="button" class="add_addr btn1 fr" title="添加收件人">+</button>
                                    </div>


                                    <div class="pkt-err"></div>
                                    <div class="packet" style="margin: 15px 0 0">
                                        <button type="button" class="del_pkt btn2 fr" title="删除包裹" style="margin-left: 7px">-</button>
                                        <button type="button" class="add_pkt btn2 fr" title="添加包裹">+</button>
                                        <div class="num clrb3 fl" style="width: 10px">1</div>
                                        <div style="margin-right: 50px; margin-left: 12px">
                                            <div class="row" style="display: inline-block; width: 100%; margin-top: -3px">
                                                <div class="attr col-xs-3 input1">                                                    
                                                    <input id="id_addr_0-0-weight" name="addr_0-0-weight" placeholder="重量" type="number" max="30" min="1" style="width:80px;" required="required"/>
                                                    (kg)</div>
                                                <div class="attr col-xs-3 input1">
                                                    <input id="id_addr_0-0-length" name="addr_0-0-length" placeholder="长度" type="number" max="105" min="1" style="width:80px;" required="required" />
                                                    (cm)</div>
                                                <div class="attr col-xs-3 input1">
                                                    <input id="id_addr_0-0-width" name="addr_0-0-width" placeholder="宽度" type="number" max="105" min="1" style="width:80px;" required="required" />
                                                    (cm)</div>
                                                <div class="attr col-xs-3 input1">
                                                    <input id="id_addr_0-0-height" name="addr_0-0-height" placeholder="高度" type="number" max="105" min="1" style="width:80px;" required="required" />
                                                    (cm)</div>
                                            </div>
                                        </div>
                                        <div class="cb"></div>
                                    </div>



                                    <input id="id_addr_0-TOTAL_FORMS" name="addr_0-TOTAL_FORMS" type="hidden" value="1" /><input id="id_addr_0-INITIAL_FORMS" name="addr_0-INITIAL_FORMS" type="hidden" value="0" /><input id="id_addr_0-MAX_NUM_FORMS" name="addr_0-MAX_NUM_FORMS" type="hidden" value="100" />
                                    <script>
                                        $(function () { add_address('addr_0', $('.formset_1')); });
                                    </script>
                                </div>


                                <div class="tar" style="margin-top: 25px">
                                    <div style="float: left; font-size: 14px; margin-top: -5px; color: #0075c2">
                                        <a href="http://send2china.co.uk/static/media/uploads/%E6%96%B0%E6%89%8B%E4%B8%93%E5%8C%BA.docx">
                                            <span style="font-weight: bold">温馨提示</span>：点击右侧"+"号添加多箱，<span style="font-weight: bold">有优惠</span>（取件费会随箱数减免）
                                        </a>
                                    </div>
                                    <asp:Button ID="btnSubmit" runat="server" OnClientClick="validateSize1()" CssClass="bg2 clrw1" style="width: 83px; height: 23px; background-position: -100px -63px; border: none; background-color: #F2F8FC; font-size: 12px" Text="立即下单" OnClick="btnSubmit_Click" />                                    
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- news -->
                    <div class="mg1 latest-news">



                        <div class="bg1 rds1 clrw1 sz16 clrb4" style="height: 38px; background-position: 0 -86px; background-repeat: repeat-x; padding: 10px 20px">
                            新闻资询
                        </div>

                        <div style="background-color: #fff; padding: 15px 20px">
                            <div style="min-height: 275px">
                                <asp:Repeater runat="server" ItemType="News" SelectMethod="GetNews" >
                                    <ItemTemplate>
                                        <a href="/news/newsdetail.aspx?id=<%#Item.Id %>" class="mg2 bg2" style="background-position: -356px -4px; background-repeat: no-repeat">
                                            <span class="clrb5 bold"><%#Item.PulishTime %></span>&nbsp;<span class="clrb4"><%#Item.Title %></span>
                                        </a>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                            <div class="mg2 tar">
                                <a href="/news/" class="clrb4 udl">更多</a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-4 col-xs-12">

                    <!-- quote parcel tracking -->
                    <div class="mg1">
                        <div class="bg1 rds1 clrw1 sz16" style="height: 38px; background-position: 0 0; background-repeat: repeat-x; padding: 10px 20px">
                            跟踪包裹
                        </div>
                        <div class="rds2" style="background-color: #fff; padding-left: 20px; padding-right: 20px">
                            <form style="margin: 0" method="post">
                                <input type="text" style="margin: 5px 0; width: 100%; height: 30px" placeholder="追踪号" name="tracking" id="tracking">
                                <div class="tar">
                                    <input type="submit" name="track" id="track" class="bg2 clrw1" style="width: 83px; height: 23px; background-position: -3px -63px; border: none; background-color: #fff" value="查询 &gt;" />
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- login / welcome dialog -->



                    <div class="mg1 login-form" id="loginDiv" runat="server">
                        <div class="bg1 rds1 clrw1 sz16" style="height: 38px; background-position: 0 -129px; background-repeat: repeat-x; padding: 10px 20px">
                            登录
                        </div>
                        <div class="rds2" style="background-color: #fff; padding: 10px 20px 0">
                            <form method="post" style="margin: 0">
                                <input type='hidden' name='csrfmiddlewaretoken' value='8aqZpoXHNqSZ280pPAWg7NUC4SD31C5B' />
                                <table style="width: 100%">
                                    <tr>
                                        <td class="sz16" style="width: 40%">名字/Email</td>
                                        <td style="width: 60%">
                                            <input autofocus="" id="id_username" name="username" required="" type="text" /></td>
                                    </tr>
                                    <tr>
                                        <td class="sz16">密码</td>
                                        <td>
                                            <input id="id_password" name="password" required="" type="password" /></td>
                                    </tr>
                                </table>
                                <div style="margin: 5px 6px">
                                    <a href="accounts/Recover.aspx">忘记密码？</a>
                                    或
            <a href="/accounts/signup/">注册</a>
                                </div>
                                <div class="tar">
                                    <input type="submit" id="login" name="login" class="bg2 clrw1" style="width: 83px; height: 23px; background-position: -3px -63px; border: none; background-color: #fff" value="登陆 &gt;" />
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="mg1 login-form" id="logoutDiv" runat="server" visible="false">
                        <div class="bg1 rds1 clrw1 sz16" style="height: 38px; background-position: 0 -129px; background-repeat: repeat-x; padding: 10px 20px">
                            欢迎回来
                        </div>
                        <div class="rds2" style="background-color: #fff; padding: 10px 20px; min-height: 143px">
                            <p>欢迎回来  <%: GetGreeting() %>.</p>

                            <p>上次登陆日期: <%: GetLastLoginTime() %></p>

                            <p>                                             
                                <a href="/accounts/logout/?next=<%: Request.Path %>" >退出</a>
                            </p>
                        </div>
                    </div>


                    <!-- mall -->
                    <div class="mg1">
                        <a href="/sudi/shop/" style="background-color: #fff">
                            <img src="/static/img/mall.png" style="width: 100%;" />
                        </a>
                    </div>

                    <!-- promotions -->
                    <div class="mg1">


                        <div class="mg1">

                            <div class="bg2 rds1 clrw1 bold" style="background-position: -15px -396px; height: 38px; padding: 10px">
                                促销
                            </div>

                            <div style="background-color: #F08B26; padding: 10px 15px">
                                <div style="min-height: 195px">
                                    <div style="margin: 5px 0 10px">
                                        <a href="#">
                                            <img src="/static/img/adv/adv1.jpg" style="width: 100%" /></a>
                                    </div>
                                    <div style="margin: 0 0 10px">
                                        <a href="#">
                                            <img src="/static/img/adv/adv2.jpg" style="width: 100%" /></a>
                                    </div>
                                    <div style="margin: 0 0 10px">
                                        <a href="#">
                                            <img src="/static/img/adv/adv3.jpg" style="width: 100%" /></a>
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>

                </div>

            </div>

            <div style="background-color: #fff; margin-bottom: 20px">
                <div class="row mg1">
                    <div class="col-sm-6 col-xs-12">
                        <div style="background-color: #fff; padding-bottom: 45px">
                            <div class="sz16 bold clrb5" style="padding: 20px 30px">
                                关于我们
                            </div>
                            <div style="padding: 0 30px 15px">
                                诚信物流 (999Parcel)是一家英国独资综合性质的国际物流公司。总部设在英国的谢菲尔德，配有大面积的仓贮仓库，可容纳大批量货物仓储。我们的业务覆 盖全英国，主营英国直邮中国的货物运输和海淘的代购及转运业务。 此外，我们对于婴幼儿食品的直邮空运，代购，转运都可以提供免费的咨询服务。
                    
                            </div>
                            <div style="margin-left: 20px">

                                <div class="fl bg2" style="display: block; width: 119px; height: 110px; background-position: 1px -110px; margin-left: 20px"></div>
                                <div class="fl bg2" style="display: block; width: 119px; height: 110px; background-position: -121px -110px; margin-left: 20px"></div>
                                <div class="fl bg2" style="display: block; width: 119px; height: 110px; background-position: -250px -110px; margin-left: 20px"></div>

                                <div class="cb"></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xs-12">
                        <img src="/static/img/about_us/partners.png" style="width: 100%" />
                    </div>
                </div>
            </div>
</asp:Content>

