<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>速递商城 | 诚信物流-可靠,快捷,实惠</title>
    <style type="text/css">
a.inc, a.dec {width:14px;height:14px;line-height:10px;display:block;font-size:16px;text-decoration:none;color:#bbb}
a.inc {border-bottom:1px solid #ddd;margin-bottom:1px}
</style>


    
<script src="/static/js/angular.min.js" type="text/javascript"></script>
<script type="text/javascript">
    function get_by_id(list, id) {
        for (var i = 0; i < list.length; i++)
            if (list[i].id == id)
                return list[i];
        return null;
    }

    var all_products = [

            {
                img_url: '/static/media/sudi2/images/blue_air_-_150x150_8.jpg',
                title: 'Blueair 650E Air Purifier 65m2 (with SmokeStop )',
                price: 679.00,
                price_rmb: (679.00 * 10).toFixed(1),
                old_price: 679.00,
                old_price_rmb: (679.00 * 10).toFixed(1),
                id: 16,
                num: 1
            }
            ,

            {
                img_url: '/static/media/sudi2/images/blue_air_-_150x150_7.jpg',
                title: ' Blueair 650E Air Purifier 65m2 (No SmokeStop)',
                price: 629.00,
                price_rmb: (629.00 * 10).toFixed(1),
                old_price: 629.00,
                old_price_rmb: (629.00 * 10).toFixed(1),
                id: 15,
                num: 1
            }
            ,

            {
                img_url: '/static/media/sudi2/images/blue_air_-_150x150_6.jpg',
                title: ' Blueair 450E Air Purifier 34m2 (With SmokeStop)',
                price: 449.00,
                price_rmb: (449.00 * 10).toFixed(1),
                old_price: 449.00,
                old_price_rmb: (449.00 * 10).toFixed(1),
                id: 14,
                num: 1
            }
            ,

            {
                img_url: '/static/media/sudi2/images/blue_air_-_150x150_5.jpg',
                title: 'Blueair 450E Air Purifier 34m2 (No SmokeStop)',
                price: 419.00,
                price_rmb: (419.00 * 10).toFixed(1),
                old_price: 419.00,
                old_price_rmb: (419.00 * 10).toFixed(1),
                id: 13,
                num: 1
            }
            ,

            {
                img_url: '/static/media/sudi2/images/blue_air_-_150x150_4.jpg',
                title: 'Blueair 270E Air Purifier 20m2 (With SmokeStop)',
                price: 315.00,
                price_rmb: (315.00 * 10).toFixed(1),
                old_price: 315.00,
                old_price_rmb: (315.00 * 10).toFixed(1),
                id: 12,
                num: 1
            }
            ,

            {
                img_url: '/static/media/sudi2/images/blue_air_-_150x150_3.jpg',
                title: 'Blueair 270E Air Purifier 20m2 (No SmokeStop)',
                price: 289.00,
                price_rmb: (289.00 * 10).toFixed(1),
                old_price: 289.00,
                old_price_rmb: (289.00 * 10).toFixed(1),
                id: 11,
                num: 1
            }
            ,

            {
                img_url: '/static/media/sudi2/images/blue_air_-_150x150_2.jpg',
                title: 'Blueair 203 Air Purifier 16m2 (With SmokeStop)',
                price: 249.00,
                price_rmb: (249.00 * 10).toFixed(1),
                old_price: 249.00,
                old_price_rmb: (249.00 * 10).toFixed(1),
                id: 10,
                num: 1
            }
            ,

            {
                img_url: '/static/media/sudi2/images/blue_air_-_150x150_1.jpg',
                title: 'Blueair 203 Air Purifier 16m2 (No SmokeStop)',
                price: 229.00,
                price_rmb: (229.00 * 10).toFixed(1),
                old_price: 229.00,
                old_price_rmb: (229.00 * 10).toFixed(1),
                id: 9,
                num: 1
            }


    ];

    function ProductController($scope, $http) {
        $scope.all_products = all_products;
        $scope.products = [];
        $scope.parcels = [];
        $scope.add = function (id, num) {
            for (var i = 0; i < parseInt(num) ; i++)
                $scope.products.push(id);
            $scope.parcels = [];
            var parcel = [];
            angular.forEach($scope.products, function (id, index) {
                var product = get_by_id(all_products, id);
                if (product)
                    parcel.push({ 'id': product.id, 'img_url': product.img_url, 'title': product.title });
                if (parcel.length == 1) {
                    $scope.parcels.unshift(parcel);
                    parcel = [];
                }
            });
            if (parcel.length > 0)
                $scope.parcels.unshift(parcel);
        };



        $scope.get_price = function () {
            var parcels = [];
            angular.forEach($scope.parcels, function (p, i) {
                var parcel = [];
                angular.forEach(p, function (product, j) {
                    parcel.push(product.id);
                });
                parcels.push(parcel);
            });
            $http({
                method: 'POST',
                url: '/sudi/shop/category/2/',
                data: $.param({ parcels: angular.toJson(parcels), box: 3 }),
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            }).success(function (data) {
                if (angular.toJson(data) == angular.toJson(parcels))
                    window.location.href = '/sudi/shop/category/2/logistics/';
            });
        };
        $scope.parcel_not_full = function () {
            if ($scope.parcels.length > 0)
                return $scope.parcels[0].length < 1;
            return true;
        };
        $scope.delete = function (i) {
            $scope.parcels.splice(i, 1);
            $scope.products = [];
            for (var j = $scope.parcels.length - 1; j >= 0; j--) {
                angular.forEach($scope.parcels[j], function (product, k) {
                    $scope.products.push(product.id);
                });
            }
        };
    }

    $(function () {
        $('.inc').click(function () {
            var $input = $(this).closest('.num').find('input');
            if (parseInt($input.val()) + 1 > 99) return;
            $input.val(parseInt($input.val()) + 1).trigger('input');
        });
        $('.dec').click(function () {
            var $input = $(this).closest('.num').find('input');
            if (parseInt($input.val()) - 1 <= 0) return;
            $input.val(parseInt($input.val()) - 1).trigger('input');
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
                
<style type="text/css">
h1 {font-size:20px;margin:15px 0 20px;}
ul.steps-bar {margin-top:15px;margin-bottom:15px;padding-left:0}
ul.steps-bar li {float:left;margin:0 5px;list-style-type:none}
ul.steps-bar li a {color:#000}
</style>

<div style="background-color:#fff;padding:1px 20px 30px;margin-top:15px;margin-bottom:30px">
    <ul class="steps-bar">
        


<li><a href="/sudi/shop/">速递商城</a></li>
 <li>&gt;</li>
<li><a href="/sudi/shop/category/2/">选择包装的箱子</a></li>
 <li>&gt;</li>
<li><a href="/sudi/shop/category/2/?box=3">选择产品</a></li>

        <li style="float:right">
            <i class="glyphicon glyphicon-list-alt"></i>
            <a href="/sudi/shop/materials/records/">我的包装材料</a>
        </li>
        <li style="float:right">
            <i class="glyphicon glyphicon-list-alt"></i>
            <a href="/sudi/shop/order/">我的订单</a>
        </li>
        <li style="float:right">
            <i class="glyphicon glyphicon-shopping-cart"></i>
            <a href="/sudi/shop/cart/">购物车</a>
        </li>
        <div style="clear:both"></div>
    </ul>
    

<div ng-app>
<div ng-controller="ProductController">

    <div class="panel panel-primary" style="float:right;width:200px;border:none;box-shadow:none">
        <div class="panel-heading">包裹:</div>
        <div style="margin:15px 0;text-align:center">
            <button ng-click="get_price()" ng-disabled="parcel_not_full()" class="btn btn-primary">快速询价 &gt;</button>
        </div>
        <div ng-repeat="parcel in parcels" style="border:1px solid #ccc;box-shadow:3px -2px 7px #888;margin-bottom:10px;padding:5px;position:relative">
            <div style="position:absolute;left:0;top:0;padding:1px 3px;background-color:#ccc;color:#fff" ng-bind="parcels.length-$index"></div>
            <div style="position:absolute;right:0;top:0;padding:1px 3px;background-color:#ccc;color:#fff;cursor:pointer" ng-click="delete($index)" title="删除">&#88;</div>
            <div ng-repeat="p in parcel" style="float:left">
                <img src="{{ p.img_url }}" style="width:120px" title="{{ p.title }}" />
            </div>
            <div style="clear:both"></div>
        </div>
    </div>

    <div class="panel panel-primary" style="margin-right:210px">
        <div class="panel-heading">空气净化器:</div>
        <div class="panel-body">
            <div class="row">
                <div ng-repeat="p in all_products" class="col-sm-3 col-xs-6" style="margin-bottom:10px">
                    <a href="javascript:void(0);">
                        <img src="{{ p.img_url }}" style="height:150px" />
                    </a>
                    <p style="text-align:center" ng-bind="p.title"></p>
                    <div style="text-align:center;color:#f00">
                        £<span ng-bind="p.price"></span>/¥<span ng-bind="p.price_rmb"></span>
                        <div ng-show="p.old_price > p.price">
                            <span style="text-decoration:line-through;color:#666;font-style:italic;font-size:12px">£<span ng-bind="p.old_price"></span>/¥<span ng-bind="p.old_price_rmb"></span></span>
                        </div>
                        <div ng-hide="p.old_price > p.price">
                            &nbsp;
                        </div>
                    </div>
                    
                    <div style="float:left" class="num">
                        <input type="text" ng-model="p.num" style="float:left;width:30px;height:30px;padding:1px 6px" />
                        <div style="float:left;margin-left:3px;margin-right:3px;border:1px solid #ccc">
                            <a href="javascript:void(0);" class="inc" title="增加">&and;</a>
                            <a href="javascript:void(0);" class="dec" title="减少">&or;</a>
                        </div>
                    </div>
                    <button ng-click="add(p.id, p.num)" style="font-size:10px;height:30px;line-height:14px;padding:6px" class="btn btn-warning">添加到包裹</button>
                </div>
            </div>
        </div>
    </div>

</div>
</div>

</div>

<script>
    $('.main-menu .shop').parent().siblings().removeClass('active').end().end().addClass('active');
</script>
</asp:Content>

