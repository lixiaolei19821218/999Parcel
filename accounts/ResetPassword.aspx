<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ResetPassword.aspx.cs" Inherits="accounts_ResetPassword" MasterPageFile="~/MasterPage.master"%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>重设密码 | 诚信物流-可靠,快捷,实惠</title>
   <link rel="stylesheet" href="/static/css/bootstrap.min.css">
    <link rel="stylesheet" href="/static/css/bootstrap-responsive.min.css">
    <link rel="stylesheet" href="/static/css/mezzanine.css">

    <link rel="stylesheet" href="/static/css/cartridge.css">

    <link rel="stylesheet" href="/static/css/theme.css">
    <script type="text/javascript" src="../../Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $('#id_email').focusout(function (e) {
                var mail = $('#id_email')[0].value;
                var json = "{email:'" + mail + "'}";
                //json = eval("(" + json + ")")
                $.ajax({
                    type: "Post",
                    url: "/accounts/signup/Default.aspx/CheckEmail",
                    contentType: "application/json; charset=utf-8",
                    data: json,
                    dataType: "json",
                    success: function (data) {
                        if (data.d) {
                            $('#email_msg')[0].hidden = "hidden";
                        }
                        else {
                            $('#email_msg')[0].hidden = "";
                        }
                    },
                    error: function (err) {
                        alert(err);
                    }
                });
            });

            $('#id_username').focusout(function (e) {
                var username = $('#id_username')[0].value;
                var json = "{username:'" + username + "'}";

                $.ajax({
                    type: "Post",
                    url: "/accounts/signup/Default.aspx/CheckUsername",
                    contentType: "application/json; charset=utf-8",
                    data: json,
                    dataType: "json",
                    success: function (data) {

                        if (data.d) {
                            $('#username_msg')[0].hidden = "hidden";
                        }
                        else {
                            $('#username_msg')[0].hidden = "";
                        }
                    },
                    error: function (err) {
                        alert(err);
                    }
                });
            });

            $('#id_password2').focusout(function (e) {

                if ($('#id_password1')[0].value == $('#id_password2')[0].value) {
                    $('#password2_msg')[0].hidden = "hidden";
                }
                else {
                    $('#password2_msg')[0].hidden = "";
                }
            });



        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <ul class="breadcrumb" style="background: none; margin-top: 15px" />
    <div style="background-color: #fff; padding: 30px">
        <fieldset>
            <form id="form1" runat="server">
               


                <div class="control-group input_id_password1">
                    <label class="control-label" for="id_password1">
                        密码
                    </label>
                    <div class="controls">
                        <input autocomplete="off" id="id_password1" name="password1" type="password" />

                        <span class="help-inline" id="password1_msg" hidden="hidden">两次输入密码不相同</span>

                    </div>
                </div>



                <div class="control-group input_id_password2 ">
                    <label class="control-label" for="id_password2">
                        密码(重复)
                    </label>
                    <div class="controls">
                        <input autocomplete="off" id="id_password2" name="password2" type="password" required="required" />

                        <span class="help-inline" id="password2_msg" hidden="hidden">两次输入密码不相同</span>

                    </div>
                </div>




                <div class="control-group">
                    <label class="control-label" id="message" runat="server">
                        
                    </label>
                    
                </div>

                <div class="form-actions">
                    <asp:Button CssClass="btn btn-primary btn-large" Text="确定" runat="server" ID="OK" OnClick="OK_Click" />
                </div>
            </form>
        </fieldset>
    </div>
</asp:Content>

