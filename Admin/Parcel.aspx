<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Parcel.aspx.cs" Inherits="Admin_Parcel" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>已发送包裹 | 诚信物流-可靠,快捷,实惠</title>
    <link href="../static/css/pager.css" rel="stylesheet" type="text/css" />  
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
    <div style="margin-top: 15px; background-color: #fff; padding: 15px">
        <form runat="server" method="post" id="placeOrder" style="padding-top: 0px">
            <div class="mg1">            
            <div class="rds2" style="background-color: #fff; padding-left: 0px; padding-right: 20px">
                <input type="text" style="margin: 10px 0; width: 30%; height: 30px" placeholder="运单号" id="content" name="content" />
                <asp:Button runat="server" CssClass="btn btn-info" Style="margin-bottom: 3px; line-height: 1" Text="查询 &gt;" ID="FindParcel" OnClick="FindParcel_Click" />
                <a href="/admin/CheckApply.aspx" style="float: right;margin: 15px 0;">返回管理页</a>
            </div>           
        </div>
                
               
                
            
          
            <table class="table table-orders" style="font-size:small;">
                <asp:Repeater ID="Rpt" runat="server" ItemType="Package" SelectMethod="GetPageApplys">
                    <HeaderTemplate>
                        <tr>
                            <th class="tac">运单号</th>
                            <th class="tac">用户名</th>
                            <th class="tac">收件人</th>                            
                            <th class="tac">收件人电话</th>
                            <th class="tac">重量</th>   
                            <th class="tac">价格</th> 
                            <th class="tac">下单时间</th>  
                            <th class="tac">赔付金额</th>   
                            <th class="tac">补交金额</th>                     
                            <th class="tac">面单</th>
                            <th class="tac">详情</th>
                            <th class="tac">赔付/补交</th>
                        </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td class="tac"><%#Item.TrackNumber %></td>
                            <td class="tac"><%#Item.Recipient.Order.User %></td>
                            <td class="tac"><%#Item.Recipient.Name %></td>
                            
                            <td class="tac"><%#Item.Recipient.PhoneNumber %></td> 
                            <td class="tac"><%#Item.Weight %></td>                            
                            <td class="tac"><%#Item.FinalCost == 0 ? Item.DeliverCost : Item.FinalCost %></td>
                            <td class="tac"><%#Item.Recipient.Order.OrderTime %></td>
                            <td class="tac" align="center"><%#Item.Compensate == null ? "-" : Item.Compensate.Value.ToString("F2") %></td>
                            <td class="tac" align="center"><%#Item.Repay == null ? "-" : Item.Repay.Value.ToString("F2") %></td>
                            <td class="tac">
                                <a href="/<%#Item.Pdf %>">下载</a>
                            </td>
                            <td colspan="1">
                                    <asp:LinkButton ID="NormalDetail" OnClick="NormalDetail_Click" runat="server" Text="详情" data-id="<%#Item.Id %>" Font-Size="Small" />
                                </td>
                            <td class="tac">
                                <a href="/Admin/Compensate.aspx?id=<%#Item.Id %>">赔付/补交</a>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
            <div class="pager">
                <% for (int i = StartPage; i < GetPageCount(); i++)
                    {
                        Response.Write(
                        string.Format("<a style=\"float:left;\" href='/admin/Parcel.aspx?page={0}&startpage={3}' {1} Style=\"vertical-align: middle;\">{2}</a>", i, i == CurrentPage ? "class='selected'" : "", i, StartPage));
                    }%>

                <asp:ImageButton ID="btnNext" ImageUrl="~/static/images/icon/next.jpg" Width="20" Height="20" runat="server" Style="vertical-align: middle; float:left;" OnClick="btnNext_Click"/>
               
            </div>
        </form>
    </div>
</asp:Content>

