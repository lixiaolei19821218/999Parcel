<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Worldpay.aspx.cs" Inherits="cart_Worldpay" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>已发送包裹 | 诚信物流-可靠,快捷,实惠</title>
    <link href="../static/css/pager.css" rel="stylesheet" type="text/css" />  
    <style type="text/css">
             .form-row input {
                height: 20px;
                padding: 2px;
                padding-left: 10px;
            }

            .form-row label {
                display: inline-block;
                padding-right: 10px;
                text-align: right;
                width: 200px;
            }

            input[type="radio"] + label {
                padding-right: 10px;
                text-align: left;
                width: auto;
            }

            .form-row select {
                height: 25px;
                padding: 2px;
                padding-left: 10px;
            }

            .payment-errors {
                color: red;
                font-size: 20px;
                font-weight: bold;
                margin-bottom: 20px;
                padding: 20px;
                text-align: center;
            }

            .token { padding-top: 20px; }

            #top-nav {
                list-style: none;
                text-align: center;
            }

            #top-nav li { display: inline-block; }

            #top-nav li a {
                color: blue;
                padding-left: 15px;
                padding-right: 10px;
                text-decoration: none;
            }

            #top-nav li+li:before {
                 content: "|";
            }

            pre {
                word-wrap: break-word;
                white-space: inherit;
            }


        </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <form id="aspnetForm" runat="server">          
        <asp:Panel runat="server" ID="RequestPanel">
            <div class="payment-errors"></div>
            

            <div class="form-row apm" style="display:none;">
                <label>APM</label>
                <select id="apm-name" data-worldpay="apm-name">
                    <option value="paypal" selected="selected">PayPal</option>
                    <option value="giropay">Giropay</option>
                    <option value="ideal">iDEAL</option>
                    <option value="sofort">Sofort</option>
                    <option value="przelewy24">Przelewy24</option>
                    <option value="alipay">Alipay</option>
                    <option value="paysafecard">PaySafeCard</option>
                    <option value="postepay">Postepay</option>
                    <option value="yandex">Yandex</option>
                    <option value="qiwi">Qiwi</option>
                    <option value="mistercash">MisterCash</option>
                </select>
            </div>
          
            <div class="form-row control-group">
                <label>Name</label>
                <input style="height:30px;" type="text" id="name" name="name" data-worldpay="name" value="Example Name" />
            </div>
            <br />
            <div class="form-row apm apm-url" style="display:none;">
                <label>
                    Success URL
                </label>
                <input type="text" id="success-url" name="success-url" placeholder='<%Response.Write( Request.Url.Scheme + "://" + Request.Url.Authority + Request.ApplicationPath.TrimEnd('/') + "/apmSuccess.aspx");%>'/>
            </div>

             <div class="form-row apm apm-url" style="display:none;">
                <label>
                    Cancel URL
                </label>
                <input type="text" id="cancel-url" name="cancel-url" placeholder='<%Response.Write( Request.Url.Scheme + "://" + Request.Url.Authority + Request.ApplicationPath.TrimEnd('/') + "/apmCancel.aspx");%>'/>
            </div>

             <div class="form-row apm apm-url" style="display:none;">
                <label>
                    Failure URL
                </label>
                <input type="text" id="failure-url" name="failure-url" placeholder='<%Response.Write( Request.Url.Scheme + "://" + Request.Url.Authority + Request.ApplicationPath.TrimEnd('/') + "/apmFailure.aspx");%>'/>
            </div>

             <div class="form-row apm apm-url" style="display:none;">
                <label>
                    Pending URL
                </label>
                <input type="text" id="pending-url" name="pending-url" placeholder='<%Response.Write( Request.Url.Scheme + "://" + Request.Url.Authority + Request.ApplicationPath.TrimEnd('/') + "/apmPending.aspx");%>'/>
            </div>

            <div class="form-row no-apm">
                <label>Card Number</label>
                <input style="height:30px;" type="text" id="card" size="20" data-worldpay="number" value="4444333322221111" />
            </div>
            <br />
            
            <div class="form-row no-apm">
                <label>CVC</label>
                <input style="height:30px;" type="text" id="cvc" size="4" data-worldpay="cvc" value="321" />
            </div>
            <br />
            <div class="form-row no-apm">
                <label>Expiration (MM/YYYY)</label>
                <select style="height:30px;" id="expiration-month" data-worldpay="exp-month">
                    <option value="01">01</option>
                    <option value="02">02</option>
                    <option value="03">03</option>
                    <option value="04">04</option>
                    <option value="05">05</option>
                    <option value="06">06</option>
                    <option value="07">07</option>
                    <option value="08">08</option>
                    <option value="09">09</option>
                    <option value="10" selected="selected">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                </select>
                <span> / </span>
                <select style="height:30px;" id="expiration-year" data-worldpay="exp-year">                  
                    <option value="2019">2019</option>
                    <option value="2020">2020</option>
                    <option value="2021">2021</option>
                </select>
            </div>
            <br />
            <div class="form-row">
                <label>Amount</label>
                <input style="height:30px;" type="text" id="amount" size="4" name="amount" value="15.23" />
            </div>
            <br />

            <div class="apmName apm"></div>

            <input name="env" type="hidden" value=""/>
            <div>
                <asp:Button CssClass="btn btn-info col-lg-3 col-lg-push-2" ID="PlaceOrder" runat="server" Text="Place Order" />
            </div>
        </asp:Panel>

        <asp:Panel runat="server" ID="SuccessPanel" Visible="false">
            <h2>Response</h2>
            <p>Order Code: <span id="order-code"><asp:Literal runat="server" ID="ResponseOrderCode" /></span></p>
            <p>Token: <span id="token"><asp:Literal runat="server" ID="ResponseToken" /></span></p>
            <p>Payment Status: <span id="payment-status"><asp:Literal runat="server" ID="ResponsePaymentStatus" /></span></p>
            <pre><asp:Literal runat="server" ID="ResponseJson" /></pre>
            <asp:Literal runat="server" ID="OrderResponse"></asp:Literal>
        </asp:Panel>
       

    </form>
</asp:Content>
