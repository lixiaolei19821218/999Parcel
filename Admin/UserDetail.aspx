<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserDetail.aspx.cs" Inherits="Admin_UserDetail" MasterPageFile="~/MasterPage.master" %>



<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
    <title>用户信息</title>    
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form runat="server" method="post" id="placeOrder" style="padding-top: 30px">
        <div>
            <label style="font-family: 'Microsoft YaHei UI';">当前用户:&nbsp;&nbsp;<%:Username %></label>
            <label style="font-family: 'Microsoft YaHei UI';float:right;">账户余额（£）:&nbsp;<%:UserBalance %></label>
            <label style="font-family: 'Microsoft YaHei UI';float:right;">订单数:&nbsp;<%:UserOrderCount %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>            
        </div>
        <hr />
        <div class="mg1">            
            <div class="rds2" style="background-color: #fff; padding-left: 0px; padding-right: 20px; padding-top:20px;">
                <asp:DropDownList runat="server" id="serviceList" />
                <asp:Button runat="server" cssclass="btn btn-info" style="margin-bottom: 3px; line-height: 1;" text="添加折扣 &gt;" ID="AddDiscount" OnClick="AddDiscount_Click" />
            <label runat="server" id="message" />
            </div>
            
        </div>

       
        <div style="margin-top: 15px; background-color: #fff; padding: 0px">
            <fieldset runat="server" id="normalField">
                <legend>折扣列表</legend>
                <table class="table table-orders" style="font-size:small;">
                    <asp:Repeater ID="Repeater1" runat="server" ItemType="Discount" SelectMethod="GetDiscounts">
                        <HeaderTemplate>
                            <tr>
                                <th class="tac">服务</th>
                                <th class="tac">审批人</th>
                                <th class="tac">审批时间</th>
                                <th class="tac">折扣</th>                                
                                <th colspan="2"></th>
                            </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="tac"><%#Item.Service.Name %></td>
                                <td class="tac"><%#Item.Approver %></td>
                                <td class="tac"><%#Item.ApproveTime %></td>
                                <td class="tac"><%#Item.Value %></td>                                
                                <td colspan="2">
                                    <input type="button" id="ButtonEdit" class="btn btn-info btn-small edit" runat="server" value="修改" data-id="<%#Item.Id %>" style="padding:0px 10px;" />
                                    <asp:Button ID="ButtonDel" CssClass="btn btn-danger btn-small del" runat="server" Text="删除" data-id="<%#Item.Id %>" OnClick="ButtonDel_Click" style="padding:0px 10px;"/>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>                
            </fieldset>
            <br />           
        </div>
        <hr />
        <div class="mg1">
            <a href="/admin/users.aspx">返回用户列表</a>
        </div>
    </form>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".edit").click(function (e) {
                if (this.value == '修改') {
                    this.value = '确定';
                    var discount = this.parentNode.previousElementSibling.innerHTML;
                    var isSuperAdmin =  '<%:IsSuperAdmin%>';
                    if (isSuperAdmin == "True"){
                        this.parentNode.previousElementSibling.innerHTML = '<input type="number" value="' + discount + '" style="width:50px;" min="0.01" required="required" />';
                    }
                    else{
                        this.parentNode.previousElementSibling.innerHTML = '<input type="number" value="' + discount + '" style="width:50px;" max="2" min="0.01" required="required" />';
                    }
                }
                else if (this.value == '确定') {                
                    
                    
                    var id = e.target.attributes["data-id"].value;
                    var discount = this.parentNode.previousElementSibling.firstChild.value;
                    
                    var isSuperAdmin = '<%:IsSuperAdmin%>';
                    if (isSuperAdmin == "False" && discount > 2) {
                        alert("折扣不能大于2镑。");
                        return;
                    }
                    this.parentNode.previousElementSibling.innerHTML = discount;
                    this.value = '修改';
                    $.ajax({
                        //要用post方式       
                        type: "Post",
                        //方法所在页面和方法名       
                        url: "UserDetail.aspx/Save",
                        data: "{'id' : '" + id + "', 'discount': '" + discount + "' }",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (data) {
                            //返回的数据用data.d获取内容                            
                        },
                        error: function (err) {
                            //alert(err);
                        }
                    });
                }
            });
        });    
    </script>
</asp:Content>