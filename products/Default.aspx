<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="product_Default" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <title>服务 | 诚信物流-可靠,快捷,实惠</title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <ul class="breadcrumb" style="background: none; margin-top: 15px"></ul>

    <div style="margin-top: 30px">
        <div style="margin-left: auto; margin-right: auto; width: 713px; padding-left: 12px; background: url(/static/img/buzou.png) 1px 0 no-repeat;">
            <a href="/" class="fl buzou" style="padding-left: 20px">快速询价</a>
            <a href="/products/" class="fl buzou active">产品选择</a>
            <a href="#" class="fl buzou" style="padding-left: 30px">包裹信息</a>
            <a href="#" class="fl buzou" style="padding-left: 30px">在线支付</a>
            <a href="#" class="fl buzou" style="padding-left: 10">邮件查收</a>
            <div class="cb"></div>
        </div>
    </div>

    <div class="sz16 bold colorb2" style="margin-top: 20px">请选择一个服务：</div>

    <div style="margin-top: 15px; background-color: #fff">
        <form runat="server">
            <table class="table table-products">
                <tr>
                    <th style="min-width: 240px">服务</th>
                    <th>描述</th>
                    <th style="min-width: 73px; text-align: center">上门取件</th>
                    <th style="min-width: 60px; text-align: center">打印</th>
                    <th style="min-width: 160px">价格(<span style="font-size: 12px">包含取件费</span>)</th>
                </tr>

                <tbody>
                    <asp:Repeater ItemType="ServiceView" EnableViewState="false"
                        SelectMethod="GetServices" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td style="vertical-align: middle">
                                    <img src="<%# Item.PictureLink %>" style="float: left; min-height: 40px; max-width: 60px; margin-right: 3px" />
                                    <%# Item.Name %>
                                </td>
                                <td>
                                    <p>
                                        <img src="<%# Item.DiscribePictureLink %>" width="350" height="78" />
                                    </p>
                                    <p><span style="font-size: small;"><%# Item.Discribe %></span></p>
                                </td>
                                <td style="vertical-align: middle; text-align: center">
                                    <i class="glyphicon glyphicon-ok"></i>
                                </td>
                                <td style="vertical-align: middle; text-align: center">
                                    <i class="glyphicon glyphicon-print"></i>
                                </td>
                                <td style="vertical-align: middle">
                                    <%# Item.GetSendPrice(Order).ToString("C", CultureInfo.CreateSpecificCulture("en-GB")) %>
                                    <br />
                                    <br />
                                    <button class="btn btn-warning" name="order" value="<%#Item.Id %>" type="submit">购买</button>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </form>
    </div>

    <div style="border: 1px solid #ccc; padding: 10px; margin-top: 30px; background: white">

        <div class="sz16 bold" style="padding: 10px 0">诚信物流谢菲尔德地区取件说明</div>
        <p>
            邮编为S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14的区域为诚信物流免费取件区域。区域S35,S36, S17,S20,S21,S26,S25,S26收取3镑每次的上面取件费。其他没有标注的区域我们无法取件，请选择UKMail上门取件。

3镑的取件费用，将自动添加到购物车里面。<a href="../static/img/SheffieldPickup.jpg">查看区域图</a>
        </p>
       
    </div>
    <div style="margin-top: 15px; margin-bottom: 35px; text-align: right">
        <a href="/" style="font-size: 20px; text-decoration: underline">&lt;&lt; 返回</a>
    </div>

</asp:Content>
