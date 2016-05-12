<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TraceEdit.aspx.cs" Inherits="Admin_TraceEdit" MasterPageFile="~/MasterPage.master"%>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>运单编辑 | 诚信物流-可靠,快捷,实惠</title>
    <style type="text/css">
        .track-list {
            font: 12px/150% Arial,Verdana,"\5b8b\4f53";
            color: #666;
        }

        li {
            margin: 10px;
        }

        .time {
            margin-right: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server"><form runat="server">
    <div class="login">
		<div class="login-grids">
			<div class="col-md-6 log">
					 <h3>编辑运单</h3>					 
					 
						 <h5>添加运单:</h5>	
						 <input type="text" id="txtTraceNumber" runat="server" />
                         <asp:Button ID="ButtonAdd" runat="server" Text="提交" OnClick="ButtonAdd_Click" />
                         <h5>已添加运单:</h5>
                         <asp:ListBox ID="ListBoxAdded" runat="server" Height="300px" Width="300px" DataTextField="Number" DataValueField="Id" AutoPostBack="true" OnSelectedIndexChanged="ListBoxAdded_SelectedIndexChanged"></asp:ListBox>
						
						 <h5 style="margin-top:30px;">查找运单:</h5>
						 <input type="password" value="">					
						 <input type="submit" value="查找">						  
					 
					
			</div>
			<div class="col-md-6 login-right">
                <h3>运单轨迹
                </h3>
					<asp:GridView ID="GridViewMessage" runat="server" BackColor="LightGoldenrodYellow" BorderColor="Tan" BorderWidth="1px" CellPadding="2" ForeColor="Black" GridLines="None" AutoGenerateColumns="False" Width="455px" Height="291px">
                        <AlternatingRowStyle BackColor="PaleGoldenrod" />
                        <Columns>
                            <asp:BoundField DataField="DateTime" />
                            <asp:BoundField DataField="Message" />
                            <asp:CommandField ShowEditButton="True" />
                            <asp:CommandField ShowDeleteButton="True" />
                        </Columns>
                        <FooterStyle BackColor="Tan" />
                        <HeaderStyle BackColor="Tan" Font-Bold="True" />
                        <PagerStyle BackColor="PaleGoldenrod" ForeColor="DarkSlateBlue" HorizontalAlign="Center" />
                        <SelectedRowStyle BackColor="DarkSlateBlue" ForeColor="GhostWhite" />
                        <SortedAscendingCellStyle BackColor="#FAFAE7" />
                        <SortedAscendingHeaderStyle BackColor="#DAC09E" />
                        <SortedDescendingCellStyle BackColor="#E1DB9C" />
                        <SortedDescendingHeaderStyle BackColor="#C2A47B" />
                    </asp:GridView>
					<h3>添加轨迹</h3>
					<input type="text" value="">
					<input type="submit" value="提交">	
			</div>
			<div class="clearfix"></div>
		</div>
	</div></form>
</asp:Content>