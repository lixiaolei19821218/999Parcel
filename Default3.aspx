<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default3.aspx.cs" Inherits="Default3" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>

<body>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:Label runat="server" Text="Label" ID="lb"></asp:Label>
                <asp:Repeater runat="server" ItemType="Order" ID="rp" >
                    <ItemTemplate>
                        <label><%#Item.SenderName %></label>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />

            </ContentTemplate>
            <Triggers>
<asp:AsyncPostBackTrigger ControlID="Button1" EventName="Click" />
</Triggers>
        </asp:UpdatePanel>
        <div>
        </div>
    </form>
</body>
</html>
