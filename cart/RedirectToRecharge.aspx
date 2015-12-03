<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RedirectToRecharge.aspx.cs" Inherits="cart_RedirectToRecharge" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>跳转 | 诚信物流-可靠,快捷,实惠</title>
    <script type="text/javascript">
        var i = 5;
        window.onload=function page_cg()
        {           
            document.getElementById("time").innerText = i;
            i--;
            if( i== 0)
            {
                window.location.href = '/accounts/UserCentre/Recharge.aspx';
            }
            setTimeout(page_cg,1000);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" >
    <div style="margin-left: auto; margin-right: auto; text-align: center;">
        账户余额不足
        <br />
        5秒后自动跳到<a href="../accounts/UserCentre/Recharge.aspx">用户充值页面</a>...还剩<span id="time" style="font-weight:bold;color: blue">5</span>秒！
        <br />
        或者返回<a href="Cart.aspx">修改购物车</a>...     
    </div>
    </form>
</body>
</html>