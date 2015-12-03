<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Sheffield.aspx.cs" Inherits="products_Sheffield" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>谢菲尔德地区服务 | 诚信物流-可靠,快捷,实惠</title>
    <script src="../Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $('select').change(function (e) {
                var count;
                if (this.parentElement.parentElement.parentElement.children[3].lastElementChild.value == '') {
                    count = 0;
                }
                else {
                    count = parseInt(this.parentElement.parentElement.parentElement.children[3].lastElementChild.value);
                }
                var price = parseFloat(this.selectedOptions[0].attributes['data-price'].value);
                this.parentElement.parentElement.parentElement.lastElementChild.innerText = (price * count).toFixed(2);

                getTotal();
            });


        })

        function countChange(e) {
            var count;
            if (e.value == '') {
                count = 0;
            }
            else {
                count = parseInt(e.value);
            }
            var price = parseFloat(e.parentElement.parentElement.children[2].children[0].children[0].selectedOptions[0].attributes['data-price'].value);
            e.parentElement.parentElement.lastElementChild.innerText = (price * count).toFixed(2);

            getTotal();
        }

        function getTotal() {
            var totalPrice = 0;
            var serviceCount = parseInt($('table')[0].children[1].childElementCount);
            for (i = 0; i < serviceCount; i++) {
                if ($('table')[0].children[1].children[i].lastElementChild.innerText == '') {
                    continue;
                }
                totalPrice += parseFloat($('table')[0].children[1].children[i].lastElementChild.innerText);
            }
            $('#total_price')[0].innerText = '£' + totalPrice.toFixed(2);

            if (totalPrice == 0.00)
            {
                $('#ButtonAddToCart')[0].disabled = true;
            }
            else
            {
                $('#ButtonAddToCart')[0].disabled = false;
            }
        }

    </script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form runat="server">
        <ul class="breadcrumb" style="background: none; margin-top: 15px"></ul>
        <div class="sz16 bold colorb2" style="margin-top: 20px">请选择您需要的服务：</div>
        <div style="margin-top: 15px; background-color: #fff">
            <table class="table table-products">
                <tr>
                    <th style="min-width: 180px">服务</th>
                    <th>描述</th>
                    <th style="min-width: 73px; text-align: center">快递公司</th>
                    <th style="min-width: 73px; text-align: center">数量</th>
                    <th style="min-width: 147px; text-align: center">价格 / £</th>
                </tr>
                <tbody runat="server">
                    <asp:Repeater runat="server" ID="rpServices" ItemType="SheffieldService" SelectMethod="GetSheffieldService">
                        <ItemTemplate>
                            <tr>                                
                                <td style="vertical-align: middle">
                                    <img src="<%#Item.PictureLink %>" style="float: left; min-height: 40px; max-width: 60px; margin-right: 3px" />
                                    <%#Item.Name %>
                                </td>
                                <td>
                                    <img src="<%#Item.DiscribePictureLink %>" width="350" height="78" />
                                    <p><span style="font-size: small;"><%#Item.Discribe1 %></span></p>
                                    <p><span style="font-size: small;"><%#Item.Discribe2 %></span></p>
                                </td>
                                <td style="vertical-align: middle; text-align: center">
                                    <i class="glyphicon glyphicon-ok">
                                        <select name="sender">                                            
                                            <asp:Repeater runat="server" ItemType="PriceListView" DataSource="<%#GetPriceListViews(Item.Id) %>">
                                                <ItemTemplate>
                                                    <option value="<%#Item.Id %>" data-price="<%#GetPrice(Item.SheffieldServiceId, Item.Id) %>"><%#Item.ShortName %></option>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </select>
                                    </i>                                   
                                </td>
                                <td style="vertical-align: middle; text-align: center">
                                    <input type="hidden" value="<%#Item.Id %>" name="service" />
                                    <input type="number" min="0" max="10000" required="required" value="0" style="width: 40px" id="id_count" name="count" oninput="countChange(this)" />
                                </td>
                                <td style="vertical-align: middle; text-align: center"></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>

        <div>
            <div style="float: left" class="total-price">总金额: <strong class="total-price" id="total_price" style="color: #f00">£0.0</strong></div>
            <div style="margin-top: -5px; margin-bottom: 10px; float: right">
                <asp:Button ID="ButtonAddToCart" ClientIDMode="Static" runat="server" CssClass="btn btn-info" Enabled="false" Style="line-height: 1" Text="下一步" OnClick="ButtonAddToCart_Click" />
            </div>
        </div>
    </form>
</asp:Content>
