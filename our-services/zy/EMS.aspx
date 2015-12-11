<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EMS.aspx.cs" Inherits="our_services_zy_EMS" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>Bpost | 诚信物流-可靠,快捷,实惠</title>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <ul class="breadcrumb" style="background: none; margin-top: 15px">
    </ul>



    <div style="background-color: #fff; padding: 30px 50px; margin-top: 30px; margin-bottom: 30px">

        

        <div style="margin-top: 10px; padding: 10px; ">
            <img src="/static/media/uploads/ems.jpg" style="float: left; margin-right: 20px; width:30%;" />
            <p>
                <h3>EMS 包税专线</h3>
                EMS 包税专线是英国诚信物流与中国邮政共同合作的英中物流专线，诚信物流为独立承运运营商， 完成和邮政速递的运营对接， 针对规定限额内的婴儿奶粉，
客户无需缴纳任何税金，安全快速通关，国内为中国邮政速递EMS派送完成。</p>
            <div style="clear: both"></div>
        </div>

        <div style="margin-top: 30px; padding: 30px 20px; margin-bottom: 30px; background-color: #ddd">
            <div style="float: left; width: 45%; margin: 10px; background-color: #fff;">
                <div style="padding: 10px 20px; background-color: #E6EBF2; color: #0075C2; font-size: 16px; font-weight: bold">婴儿奶粉包税</div>
                <div style="padding: 20px; min-height: 100px">
                    针对6罐之内的任何混装的婴儿奶粉 （牛栏，爱他美，喜宝，SMA），清关产生的税金由诚信物流代缴，客户无需支付。
  一切以客户准确申报后为准。</div>
            </div>
            <div style="float: left; width: 45%; margin: 10px; background-color: #fff;">
                <div style="padding: 10px 20px; background-color: #E6EBF2; color: #0075C2; font-size: 16px; font-weight: bold">清关渠道</div>
                <div style="padding: 20px; min-height: 100px">任何合法自营EMS渠道都需要按照中华人民共和国海关条例进行清关，都需要报备收件人身份信息，
            此线路也不例外，所谓包税，其实是诚信物流支付清关过程产生的税金。</div>
            </div>
            <div style="float: left; width: 45%; margin: 10px; background-color: #fff;">
                <div style="padding: 10px 20px; background-color: #E6EBF2; color: #0075C2; font-size: 16px; font-weight: bold">使用额度</div>
                <div style="padding: 20px; min-height: 100px">同一收件人（收件人身份证号码，收件地址和手机号）单次最多可发2箱，每月累计不可超过8箱。
              （不同收件人身份证号码和手机号 同一地址）单次可发4箱 每月累计不可超过20箱</div>
            </div>
            <div style="float: left; width: 45%; margin: 10px; background-color: #fff;">
                <div style="padding: 10px 20px; background-color: #E6EBF2; color: #0075C2; font-size: 16px; font-weight: bold">客户要求</div>
                <div style="padding: 20px; min-height: 100px">
                    收件人身份信息报备  根据中国海关规定，为防止变相走私，
             证明包裹内物品确实为个人自用，客户需要在下单的时候输入收件人身份证号码。
   包税专线目前仅限于婴儿奶粉，如果客户用专线邮寄其他个人物品而导致海关不放行，诚信物流不会承担赔偿。
                </div>
            </div>
            

            <div style="clear: both"></div>
        </div>
    </div>
    <script>
        $('.main-menu .zy').parent().siblings().removeClass('active').end().end().addClass('active');
    </script>
</asp:Content>
