<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Recover.aspx.cs" Inherits="accounts_Recover" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>找回密码 | 诚信物流-可靠,快捷,实惠</title>
   

    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   



    <div style="background-color: #fff; padding: 30px">
        <fieldset>
            <form method="post" runat="server">
               <li style="font-family:YouYuan;">输入您的用户名，您将收到一封包含可点击的链接的邮件，在您的邮箱里点击该链接后可登录并修改密码。</li>
                <br />
                <br />
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

                <br />
                <br />
                <div class="form-actions">
                    <asp:Button runat="server" ID="Reset" cssclass="btn btn-primary btn-large" type="submit" text="重置密码" OnClick="Reset_Click"/>
                </div>
            </form>
        </fieldset>
    </div>

    
</asp:Content>
