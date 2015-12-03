<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NewsEdit.aspx.cs" Inherits="Admin_NewsEdit" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>新闻编辑</title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form runat="server">
    <div class="pane1 mg1">


        <div class="bg1 rds1 clrw1 sz16 bold" style="height: 38px; background-position: 0 -43px; background-repeat: repeat-x; padding: 10px 20px">
            标题
        </div>

        <div class="rds2" style="background-color: #F2F8FC; text-align: center; border-left: 1px solid #0075C2; border-right: 1px solid #0075C2; border-bottom: 1px solid #0075C2; padding: 20px 15px 20px; height: 100px;">
            <asp:TextBox ID="TextBoxTilte" runat="server" Width="100%" Height="100%" ></asp:TextBox>

        </div>
    </div>
    <div class="pane1 mg1">


        <div class="bg1 rds1 clrw1 sz16 bold" style="height: 38px; background-position: 0 -43px; background-repeat: repeat-x; padding: 10px 20px">
            内容
        </div>

        <div class="rds2" style="background-color: #F2F8FC; text-align: center; border-left: 1px solid #0075C2; border-right: 1px solid #0075C2; border-bottom: 1px solid #0075C2; padding: 20px 15px 20px; margin-bottom: 0px; height: 500px;">
            <asp:TextBox ID="TextBoxContent" runat="server" TextMode="MultiLine" Width="100%" Height="100%" ></asp:TextBox>
        </div>
    </div>
        <hr />
        <div style="padding: 0px; margin-top:0px;margin-bottom:30px; float:right;">

                 

                    <asp:Button ID="Save" runat="server" CssClass="btn btn-info" Text="保存" style="width:100px;" OnClick="Save_Click" />
                    

                    
                </div>
        </form>
</asp:Content>
