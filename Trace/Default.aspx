<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Trace_Default" MasterPageFile="~/MasterPage.master"%>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>运单查询 | 诚信物流-可靠,快捷,实惠</title>
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
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<div class="login">
		<div class="login-grids">
			<div class="col-md-6 log">
					 <h3>跟踪运单</h3>
					 <p>欢迎使用运单跟踪, 请输入运单号。</p>
					 <p>如果查询结果有误，请联系我们，我们会尽快为您处理。</p>
					 <form>
						 <h5>运单号:</h5>	
						 <input type="text" value="" name="txtTraceNumber" id="txtTraceNumber" />						 			
						 <input type="submit" value="查询"/>						  
					 </form>					
			</div>
			<div class="col-md-6 login-right">
					<h3>运单轨迹</h3>
                <div class="track-list">
                    <ul>
                        <asp:Repeater runat="server" ItemType="TraceMessage" SelectMethod="GetTraceMessages">
                            <ItemTemplate>
                                <li><i class="node-icon"></i><span class="time"><%#Item.DateTime %></span><span class="txt"><%#Item.Message %></span></li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </div>
            </div>
			<div class="clearfix"></div>
		</div>
	</div>

</asp:Content>