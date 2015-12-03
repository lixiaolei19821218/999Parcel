<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default2" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" Runat="Server">
    <title>速递服务 | 诚信物流-可靠,快捷,实惠</title>
    <script>
        $(document).ready(function () {
           

            $('#service')[0].setAttribute('class', 'active');
        });
    </script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <ul class="breadcrumb" style="background: none; margin-top: 15px"></ul>



    <div style="background-color: #fff; padding: 30px 50px; margin-top: 30px; margin-bottom: 30px">
        <h1>速递服务</h1>

        <p>诚信物流 (Send2China)是一家英国独资综合性质的国际物流公司。总部设在英国的苏塞克斯郡，配有大面积的仓贮仓库，可容纳大批量货物仓储。我们的业务覆盖全英国，主营英国直邮中国的货物运输和海淘的代购及转运业务。 此外，我们对于婴幼儿食品的直邮空运，代购，转运都可以提供免费的咨询服务。</p>


        <div style="background-color: #EBF4FA">
            <img src="/static/img/static/gjkd.png" style="float: left; padding: 20px 40px" />
            <a style="padding: 20px; display: block; color: #333" href="/our-services/zy/">
                <h2>国际快递</h2>

                <p>可容纳大批量货物仓储。我们的业务覆盖全英国，主营英国直邮中国的货物运输和海淘的代购及转运业务。 此外，我们对于婴幼儿食品的直邮空运，代购，转运都可以提供免费的咨询服务。</p>

            </a>
            <div style="clear: both"></div>
        </div>

        <div style="background-color: #EEEEEF; margin-top: 10px">
            <img src="/static/img/static/hwcc.png" style="float: right; padding: 20px 40px" />
            <a style="padding: 20px; display: block; color: #333" href="/our-services/yun/">
                <h2>海外仓储</h2>

                <p>个人云仓库为您解决个人物品存储和跨国包裹配送。无需代购，自主选购。折扣推荐，优惠多多。集中管理，集中配送，更能节省运费。免费空间，免费存储，超低跨国运费。</p>

            </a>
            <div style="clear: both"></div>
        </div>

        <div style="background-color: #FEF4ED; margin-top: 10px">
            <img src="/static/img/static/hwdg.png" style="float: left; padding: 20px 40px" />
            <a style="padding: 20px; display: block; color: #333" href="/our-services/dg/">
                <h2>速递商城</h2>

                <p>快速专业采购；各类打折信息汇总；人民币结算；物品全程跟踪；一站式服务。您只要相中产品，剩下的工作我们为您完成。</p>

            </a>
            <div style="clear: both"></div>
        </div>

        <div style="margin: 30px -50px; background-color: #2F3346; padding: 10px 50px 30px">
            <h2 style="color: #fff">我们的核心价值</h2>
            <img src="/static/img/static/hx1.png" style="float: left; padding: 0 13px" />
            <img src="/static/img/static/hx2.png" style="float: left; padding: 0 13px" />
            <img src="/static/img/static/hx3.png" style="float: left; padding: 0 13px" />
            <img src="/static/img/static/hx4.png" style="float: left; padding: 0 13px" />
            <div style="clear: both"></div>
        </div>

        <div style="margin-top: 30px">
            <h2>我们的运营商</h2>
            <img src="/static/img/static/fws.png" />
        </div>
    </div>
    <script>
        $('.main-menu .our-services').parent().siblings().removeClass('active').end().end().addClass('active');
</script>
</asp:Content>

