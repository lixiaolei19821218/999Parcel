<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ErrorControl.ascx.cs" Inherits="ErrorControl" %>
<asp:Panel ID="ErrorPanel" runat="server" Visible="false">
    <p>Error Code: <asp:Literal runat="server" ID="ErrorCode"></asp:Literal></p>
    <p>HTTP Status: <asp:Literal runat="server" ID="HttpStatus"></asp:Literal></p>
    <p>Error Description: <asp:Literal runat="server" ID="ErrorDescription"></asp:Literal></p>
    <p>Error Message: <asp:Literal runat="server" ID="ErrorMessage"></asp:Literal></p>
</asp:Panel>