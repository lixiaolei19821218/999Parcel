<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Activate.aspx.cs" Inherits="accounts_signup_Activate" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>激活账号 | 诚信物流-可靠,快捷,实惠</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <fieldset>
            <form method="post" runat="server">
                <br />
               <li style="font-family:YouYuan;">如果您长时间没有收到激活账号的邮件，请在此处填写您注册时使用的用户名并点击激活按钮，系统重新发送一份邮件给您。</li>
                <br />
                <br />
                <div class="control-group input_id_username">
                    <label class="control-label" for="id_username">
                        用户名
                    </label>
                    <div class="controls">
                        <input autofocus="" id="username" name="username" required="required" type="text" runat="server" />

                        <span class="help-inline"></span>

                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label" id="message" runat="server">
                        
                    </label>
                    
                </div>


                <div class="form-actions">
                    <asp:Button runat="server" ID="Activate" OnClick="Activate_Click" cssclass="btn btn-primary btn-large" type="submit" text="激活" />
                </div>
            </form>
        </fieldset>
</asp:Content>
