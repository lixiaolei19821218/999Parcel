﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TraceEdit.aspx.cs" Inherits="Admin_TraceEdit" MasterPageFile="~/MasterPage.master"%>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>运单编辑 | 诚信物流-可靠,快捷,实惠</title>
    <style type="text/css">
        .track-list {
            font: 12px/150% Arial,Verdana,"\5b8b\4f53";
            color: #666;
        }

        .track-list li {
            margin: 10px;
        }

        .time {
            margin-right: 20px;
        }
    </style>
    <script type="text/javascript" src="/Scripts/My97DatePicker/WdatePicker.js"></script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server"><form runat="server">
    <div class="login">       
         
		<div class="login-grids">           
			<div class="col-md-6 log">
					 <h3>编辑运单</h3>		 
						 <h5>添加运单:</h5>	
						 <input type="text" id="txtTraceNumber" runat="server" />
                         <input type="submit" id="btnAddTraceNumber" name="btnAddTraceNumber" value="提交"/><asp:Label ID="labelError" ForeColor="Red" runat="server" Visible="false" /> 
                         <h5 style="margin-top:30px;">已添加运单:</h5>
                         <asp:ListBox ID="ListBoxAdded" runat="server" Height="300px" Width="300px" DataTextField="Number" DataValueField="Id" AutoPostBack="true" OnSelectedIndexChanged="ListBoxAdded_SelectedIndexChanged" SelectionMode="Multiple"></asp:ListBox>
						
						 <h5 style="margin-top:30px;">查找运单:</h5>
						 <input type="password" value="">					
						 <input type="submit" value="查找">		             
			</div>
			<div class="col-md-6 login-right">
                <h3>运单轨迹
                </h3>
					<asp:GridView ID="GridViewMessage" runat="server" BackColor="LightGoldenrodYellow" BorderColor="Tan" BorderWidth="1px" CellPadding="2" ForeColor="Black" GridLines="None" AutoGenerateColumns="False" OnRowDeleting="GridViewMessage_RowDeleting" OnRowEditing="GridViewMessage_RowEditing" SelectedRowStyle-BackColor="YellowGreen" Width="501px">
                        <AlternatingRowStyle BackColor="PaleGoldenrod" />
                        <Columns>
                            <asp:BoundField DataField="Id">                            
                            <ItemStyle Width="60px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="DateTime">
                                <ControlStyle Width="100px" />
                                <ItemStyle Width="100px" />
                            </asp:BoundField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <%# Eval("Message")%> 
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox_row_message" runat="server" Width="50px"></asp:TextBox>
                                    <asp:HiddenField ID="HiddenField_row_message" runat="server" Value='<%# Eval("name") %>' />
                                </EditItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:CommandField ButtonType="Button" ShowDeleteButton="True" />
                            <asp:CommandField ButtonType="Button" ShowEditButton="True" />
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
					<h3 style="margin-top:30px;">添加轨迹</h3>

                <input type="text" id="txtDateTime" runat="server" onfocus="WdatePicker({dateFmt:'yyyy年MM月dd日 HH时mm分ss秒'})" class="Wdate" style="width: 300px; height: 30px; margin: 5px 0px;" />
                <input type="text" id="txtMessage" runat="server"  style="width: 300px; height: 30px; margin: 5px 0px;"/>
                <input type="submit" id="btnAddTraceMessage" name="btnAddTraceMessage" value="提交" /><asp:Label ID="labelError2" ForeColor="Red" runat="server" Visible="false" /> 
			</div>
			<div class="clearfix"></div>
		</div>
	</div></form>
</asp:Content>