<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WorldPay.aspx.cs" Inherits="WorldPay" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form action="https://secure-test.worldpay.com/wcc/purchase" method="post">
        <!-- This next line contains the testMode parameter - it specifies that the submission is a test submission -->
        <input type="hidden" name="testMode" value="100" />
        <!-- This next line contains a mandatory parameter. Put your Installation ID inside the quotes after value= -->
        <!-- You will need to get the installation ID from your Worldpay account. Login to your account, click setting and under installations
you should have an option called select junior and a number, put the number between "" e.g. "123456"-->
        <input type="hidden" name="instId" value="1360646" />
        <!-- Another mandatory parameter. Put your own reference identifier for the item purchased inside the quotes after value= -->
        <input type="hidden" name="cartId" value="test001" />
        <!-- Another mandatory parameter. Put the total cost of the item inside the quotes -->
        <input type="hidden" name="amount" value="10.99" />
        <!-- Another mandatory parameter. Put the code for the purchase currency inside the quotes after value= -->
        <input type="hidden" name="currency" value="GBP" />
        <!-- This creates the button. When it is selected in the browser, the form submits the purchase details to us. -->
        <input type="submit" value="Buy This" />
    </form>
</body>
</html>
