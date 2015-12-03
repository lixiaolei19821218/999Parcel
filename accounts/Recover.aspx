<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Recover.aspx.cs" Inherits="accounts_Recover" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>找回密码 | 诚信物流-可靠,快捷,实惠</title>
    <link rel="shortcut icon" type="image/x-icon" href="/static/img/favicon-gf.ico">


    <link href="/static/bootstrap3/css/bootstrap.min.css" rel="stylesheet">
    <link href="/static/bootstrap3/css/bootstrap-theme.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/guofan.css">



    <link rel="stylesheet" href="/static/css/bootstrap.min.css">
    <link rel="stylesheet" href="/static/css/bootstrap-responsive.min.css">
    <link rel="stylesheet" href="/static/css/mezzanine.css">

    <link rel="stylesheet" href="/static/css/cartridge.css">

    <link rel="stylesheet" href="/static/css/theme.css">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <ul class="breadcrumb" style="background: none; margin-top: 15px">
    </ul>




    <div style="background-color: #fff; padding: 30px">
        <fieldset>
            <form method="post" runat="server">
               

                <div class="control-group input_id_username">
                    <label class="control-label" for="id_username">
                        用户名
                    </label>
                    <div class="controls">
                        <input autofocus="" id="id_username" name="username" required="required" type="text" />

                        <span class="help-inline"></span>

                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label" id="message" runat="server">
                        
                    </label>
                    
                </div>


                <div class="form-actions">
                    <asp:Button runat="server" ID="Reset" cssclass="btn btn-primary btn-large" type="submit" text="重置密码" OnClick="Reset_Click"/>
                </div>
            </form>
        </fieldset>
    </div>

    <p>输入您的用户名，您将收到一封包含可点击的链接的邮件，在您的邮箱里点击该链接后可登录并修改密码。</p>
</asp:Content>
