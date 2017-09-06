<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="accounts_signup_Edit" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>更新个人资料 | 诚信物流-可靠,快捷,实惠</title>
    <link rel="stylesheet" href="/static/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="/static/css/bootstrap-responsive.min.css"/>
  <link href="/static/bootstrap3/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="/static/css/guofan.css">
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
    <script src="/static/js/contact.js"></script>
    <script src="/static/bootstrap3/js/jquery-1.11.1.min.js"></script> 
    <script type="text/javascript" src="/Scripts/jquery-1.8.0.min.js"></script>
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
                <div class="control-group input_id_first_name ">
                    <label class="control-label" for="id_first_name">名字</label>
                    <div class="controls">
                        <input autofocus="" id="id_first_name" maxlength="30" name="first_name" type="text" required="required" value="<%:ApUser == null ? "" : ApUser.FirstName %>"  style="height:inherit;"/>

                        <span class="help-inline"></span>
                    </div>
                </div>
                <div class="control-group input_id_last_name">
                    <label class="control-label" for="id_last_name">
                        姓氏
                    </label>
                    <div class="controls">
                        <input id="id_last_name" maxlength="30" name="last_name" type="text" value="<%:ApUser == null ? "" : ApUser.LastName %>" required="required" style="height:inherit;"/>

                        <span class="help-inline"></span>

                    </div>
                </div>
                <div class="control-group input_id_email">
                    <label class="control-label" for="id_email">
                        电子邮件地址
                    </label>
                    <div class="controls">
                        <input id="id_email" maxlength="75" name="email" required="required" type="email" value="<%:MsUser == null ? "" : MsUser.Email %>" style="height:inherit;"/>

                        <span class="help-inline" id="email_msg" hidden="hidden">该邮件地址已注册</span>

                    </div>
                </div>
                <div class="control-group input_id_phone">
                    <label class="control-label" for="id_phone">
                        Phone
                    </label>
                    <div class="controls">
                        <input id="id_phone" maxlength="15" name="phone" type="text" required="required" value="<%:ApUser == null ? "" : ApUser.CellPhone %>" style="height:inherit;" />

                        <span class="help-inline"></span>

                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" id="message" runat="server" style="font-family:YouYuan;">
                        
                    </label>                    
                </div>
                <div class="form-actions">
                    <asp:Button ID="btnSave" CssClass="btn btn-primary btn-medium" Text="修改" runat="server" OnClick="btnSave_Click" />
                    <a href="/accounts/UserCentre/Default.aspx" style="float:right;">返回个人中心</a>
                </div>
            </form>
        </fieldset>
    </div>
</asp:Content>
