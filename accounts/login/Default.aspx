﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>登录 | 诚信物流-可靠,快捷,实惠</title>

    <link rel="stylesheet" href="/static/css/bootstrap.min.css">
    <link rel="stylesheet" href="/static/css/bootstrap-responsive.min.css">

    <script type="text/javascript">
        function refreshImg() {
            codeImg.src = codeImg.src + "?";
        }
    </script>
    <style type="text/css">
        a{
            font-size:medium;
        }
        #welcomeDiv{
            font-size:medium;
        }
        #loginDiv{
            font-size:medium;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <ul class="breadcrumb" style="background: none; margin-top: 15px">
    </ul>






    <div style="background-color: #fff; padding: 30px">
        <fieldset>
            <form method="post" runat="server">


                <div class="control-group error non-field-errors" style="visibility:collapse; color:red;" id="message" runat="server">

                    

                </div>


                <input type="hidden" name="referrer" value="https://999Parcel.com/">
                <input type='hidden' name='csrfmiddlewaretoken' value='k2p9EtXXVFGD9dgRVAgN06Tb4EAFNYsA' />




                <div class="control-group input_id_username">
                    <label class="control-label" for="id_username">
                        用户名或电子邮件地址
                    </label>
                    <div class="controls">
                        <input autofocus="" id="id_username" name="username" required="" type="text" style="height:30px;"/>

                        <span class="help-inline"></span>

                    </div>
                </div>



                <div class="control-group input_id_password">
                    <label class="control-label" for="id_password">
                        密码
                    </label>
                    <div class="controls">
                        <input id="id_password" name="password" required="" type="password" style="height:30px;"/>

                        <span class="help-inline"></span>

                    </div>
                </div>
                <div class="control-group input_id_password">
                    <label class="control-label" for="id_password">
                        验证码
                    </label>
                    <div class="controls">
                        <input id="id_validateCode" name="validateCode" required="" type="text" title="请输入右侧验证码。" style="height:30px;"/>
                        <img id="codeImg" name="codeImg" onclick="refreshImg()" runat="server" src="/ValidateCode.aspx" title="看不清楚？点击刷新。" style="margin-bottom:10px;"/>
                        <span class="help-inline"></span>

                    </div>
                </div>


                <div class="form-actions">
                    <input class="btn btn-primary btn-large" type="submit" value="登陆">
                </div>
            </form>
        </fieldset>
    </div>


    <p>没有账户？立即<a href="/accounts/signup/">注册</a></p>


    <p>如果忘记密码，您也可以 <a href="../Recover.aspx">重置您的密码</a>。</p>

</asp:Content>

