<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default3.aspx.cs" Inherits="Default3" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="/js/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="/js/bootstrap.min.js"></script>
    <script src="/js/distpicker.data.js"></script>
    <script src="/js/distpicker.js"></script>
    <script type="text/javascript">
        $("#distpicker3").distpicker({
            province: '浙江省',
            city: '杭州市',
            district: '西湖区'
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div data-toggle="distpicker" id="distpicker3">
                <!-- container -->
                <select id="eprovinceName" data-province="浙江省" name="provinceName"></select>
              <select id="ecityName" data-city="杭州市" name="cityName"></select>
              <select id="edistrictName" data-district="西湖区" name="districtName"></select>
              
            </div>
            <input type='button' id="btn" value="btc" />
        </div>
    </form>
</body>
    <script type="text/javascript">
        $('#btn').click(function () {
            $('#eprovinceName').attr('data-province', '浙江省');
            $('#ecityName').attr('data-city', '杭州市');
            $('#edistrictName').attr('data-district', '上城区');
            //$("#distpicker3").distpicker('reset', true);
            $("#distpicker3").distpicker('destroy');
            $("#distpicker3").distpicker({
                province: '浙江省',
                city: '杭州市',
                district: '上城区',
                autoSelect: false
            });

        });
       
    </script>
</html>
