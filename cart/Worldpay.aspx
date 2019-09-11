<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Worldpay.aspx.cs" Inherits="cart_Worldpay" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Globalization" %>
<%@ Register TagPrefix="uc" TagName="ErrorControl" Src="~/ErrorControl.ascx" %>

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
            <div class="payment-errors"><asp:label runat="server" ID="msg" ForeColor="Red"/></div>
          
            <div class="form-row control-group">
                <label>Name</label>
                <input style="height:30px;" type="text" id="name" name="name" data-worldpay="name" value="999 Parcel" />
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
                <input style="height:30px;" type="text" id="card" name="number" size="20" data-worldpay="number" value="4444333322221111" />
            </div>
            <br />
            
            <div class="form-row no-apm">
                <label>CVC</label>
                <input style="height:30px;" type="text" id="cvc" name="cvc" size="4" data-worldpay="cvc" value="321" />
            </div>
            <br />
            <div class="form-row no-apm">
                <label>Expiration (MM/YYYY)</label>
                <select style="height:30px;" id="expiration-month" name="exp-month" data-worldpay="exp-month">
                    <option value="01">01</option>
                    <option value="02">02</option>
                    <option value="03">03</option>
                    <option value="04">04</option>
                    <option value="05">05</option>
                    <option value="06">06</option>
                    <option value="07">07</option>
                    <option value="08">08</option>
                    <option value="09">09</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                </select>
                <span> / </span>
                <select style="height:30px;" id="expiration-year" name="exp-year" data-worldpay="exp-year">                    
                    <option value="<%:DateTime.Now.Year %>"><%:DateTime.Now.Year %></option>
                    <option value="<%:DateTime.Now.AddYears(1).Year %>"><%:DateTime.Now.AddYears(1).Year %></option>
                    <option value="<%:DateTime.Now.AddYears(2).Year %>"><%:DateTime.Now.AddYears(2).Year %></option>
                    <option value="<%:DateTime.Now.AddYears(3).Year %>"><%:DateTime.Now.AddYears(3).Year %></option>
                    <option value="<%:DateTime.Now.AddYears(4).Year %>"><%:DateTime.Now.AddYears(4).Year %></option>
                    <option value="<%:DateTime.Now.AddYears(5).Year %>"><%:DateTime.Now.AddYears(5).Year %></option>
                    <option value="<%:DateTime.Now.AddYears(6).Year %>"><%:DateTime.Now.AddYears(6).Year %></option>
                    <option value="<%:DateTime.Now.AddYears(7).Year %>"><%:DateTime.Now.AddYears(7).Year %></option>
                    <option value="<%:DateTime.Now.AddYears(8).Year %>"><%:DateTime.Now.AddYears(8).Year %></option>
                    <option value="<%:DateTime.Now.AddYears(9).Year %>"><%:DateTime.Now.AddYears(9).Year %></option>                   
                </select>
            </div>
            <br />
            <div class="form-row">
                <label>Amount</label>
                <%:Session["Cost"] %>
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
       
         <table border="0" style="float: right;">
                        <tbody>
                            <tr>
                                <td style="width:70px;">
                                    <input name="op-DPChoose-ECMC^SSL" type="image" src="/static/img/logos/99b8b93b12bbdb95c94a3ded6239461.png" alt="Mastercard" />                                    
                                </td>
                                <td style="width:70px;">
                                    <input name="op-DPChoose-VISA^SSL" type="image" src="/static/img/logos/c514e1e08db201b45993b344e9f312e.png" alt="Visa" />                               
                                </td>
                                <td style="width:70px;">
                                    <input name="op-DPChoose-Maestro^SSL" type="image" src="/static/img/logos/78b6bdb195e7fc394b09c80f2b0a6e4.png" alt="Maestro" />                                    
                                </td>
                                <td style="width:70px;">
                                    <input name="op-DPChoose-JCB^SSL" type="image" src="/static/img/logos/8d0fb151dc66e94b4969fe63748a473.png" alt="JCB" />                                    
                                </td>
                                <td style="width:70px;">
                                    <input name="op-DPChoose-WP^SSL" type="image" src="/static/img/logos/d9c9a010ab363d78b82a3aff5837f86.png" alt="worldpay" />                                    
                                </td>
                               
                            </tr>
                        </tbody>
                    </table>
    </form>
</asp:Content>
