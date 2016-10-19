<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Providers.aspx.cs" Inherits="products_Providers" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <title>运营商 | 诚信物流-可靠,快捷,实惠</title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <ul class="breadcrumb" style="background: none; margin-top: 15px"></ul>



    <div class="sz16 bold colorb2" style="margin-top: 20px; font-family:YouYuan;">请选择一个运营商：</div>

    <div style="margin-top: 15px; background-color: #fff">
        <form runat="server">
            <table class="table table-products">
                <tr>
                    <th style="min-width: 240px">运营商</th>
                    <th>描述</th>
                    <th style="min-width: 160px">价格(<span style="font-size: 12px">包含取件费</span>)</th>
                </tr>

                <tbody>
                    <asp:Repeater ItemType="Provider" EnableViewState="false" SelectMethod="GetProviders" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td style="vertical-align: middle">
                                    <img src="<%# Item.PictureLink %>" style="float: left; min-height: 40px; max-width: 60px; margin-right: 3px" />
                                    <%# Item.Name %>
                                </td>
                                <td>
                                    <p>
                                        <img src="<%# Item.DiscriblePictureLink %>" width="350" height="78" />
                                    </p>
                                    <p><span style="font-size: small;"><%# Item.Discrible %></span></p>
                                </td>                                                           
                                <td style="vertical-align: middle">
                                    <%# GetLowestPrice(Item).ToString("C", CultureInfo.CreateSpecificCulture("en-GB")) %>
                                    <br />
                                    <br />
                                    <button class="btn btn-warning" name="order" value="<%#Item.Id %>" type="submit">购买</button>                                    
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>

                </tbody>
            </table>
        </form>
    </div>
</asp:Content>
