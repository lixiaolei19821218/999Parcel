document.write('<script src="/js/distpicker.data.js"></script>')
document.write('<script src="/js/distpicker.js"></script>')

var sortable_option = {
    connectWith: ".con",
    handle: '.ordering',
    opacity: 0.5,
    axis: 'y',
    placeholder: 'placeholder',
    forcePlaceholderSize: true,
    receive: function(event, ui) {
        updateParcels();
    },
    items: '> li'
};

function updateForms(formClass, prefix) {
    var forms = $(formClass),
        totalForms = $('#id_' + prefix + '-TOTAL_FORMS'),
        formCount = forms.length,
        childElementSelector = 'input,select,textarea,label,div';
    totalForms.val(formCount);
    for (var i = 0; i < formCount; i++) {
        forms.eq(i).find('.ordering_number').html(i + 1);
        forms.eq(i).find('.addr_item_num').html(i + 1);
        forms.eq(i).find('.save_addr').val(i+1);
        forms.eq(i).find('.addr_insurance').attr('name', 'addr_'+i+'_insurance');
        forms.eq(i).find('.addr_insurance').attr('id', 'addr_'+i+'_insurance');
        forms.eq(i).find(childElementSelector).each(function() {
            updateElementIndex($(this), prefix, i);
        });
        // If we're updating parcel, also update what addr it belongs to
        if (prefix == "parcel") {
            var addrLi = forms.eq(i).closest('.addrItem'),
                addrIdName = addrLi.find('[id$=name]')[0].id,
                regex = /id_addr-(\d+)-/,
                addrId = addrIdName.match(regex)[1];
            forms.eq(i).find('[id$=address_id]').val(addrId);
            forms.eq(i).find('input[name$=-content-TOTAL_FORMS]').val(forms.eq(i).find('.mx').length);
        }
    }
}

function updateElementIndex(elem, prefix, ndx) {
    var idRegex = new RegExp(prefix + '-(\\d+|__prefix__)-'),
    replacement = prefix + '-' + ndx + '-';
    if (elem.attr("for")) elem.attr("for", elem.attr("for").replace(idRegex, replacement));
    if (elem.attr('id')) elem.attr('id', elem.attr('id').replace(idRegex, replacement));
    if (elem.attr('name')) elem.attr('name', elem.attr('name').replace(idRegex, replacement));
}

function updateParcels() {
    updateForms(".parcelItem", "parcel");
}

function updateAddrs() {
    updateForms(".addrItem", "addr");
    updateParcels();
}

function addAddr() {
    var addrLi = $(this).closest('li');
    //~ var tmplMarkup = _.template($('#template_addr').html())();
    //~ var node = $(tmplMarkup);
    //~ var node = $(addrLi).clone(true);
    var node = addrLi.clone();
    node.find('.parcelItem').not(':first').remove();
    node.find('[id$=TOTAL_FORMS]').val(1);
    node.find('input[type="text"]').val('');
    node.find('.mx_total').html('0');
    node.find('.py_fields').hide();
    node.find('.py_fields').find('.py_name').html('&nbsp;');
    node.find('.py_fields').find('.py_city').html('&nbsp;');
    node.find('.py_fields').find('.py_street').html('');
    node.find('.cn_name_en').html('');
    node.find('.cn_city_en').html('');
    node.find('.cn_street_en').html('');
    node.find('.addr_item_num').html(addrLi.parent().find('.addrItem').length + 1);
    addrLi.parent().append(node);
//    node.find('.con').sortable(sortable_option);
    updateAddrs();
    $('.dist').distpicker();

    var i = addrLi.find('.parcelItem:first').find('span.ordering_number').text() - 1;
    var pd = $('#details').find('.parcelDetail').eq(i).clone();
    $('#details').append(pd);
    var count = $('#details').find('.parcelDetail').length;
    pd.find('span:first').html(count);

    recalcAll();
}

function addParcel() {
    var addrLi = $(this).closest('li'),
        tmplMarkup = _.template($('#template_parcel').html())(),
        node = $(tmplMarkup),
        parcelLi = addrLi.find('li:last')
    parcelLi.after(node);
    updateParcels();
   
}

function delAddr() {
    var totalForms = $('#id_addr-TOTAL_FORMS'),
        addrLi = $(this).closest('li');
    if (totalForms.val() == 1)
        return;
    if ($('#id_parcel-TOTAL_FORMS').val() == 1)
        if ($('.parcelItem', addrLi).length)
            return;

    addrLi.remove();
    updateAddrs();

    var start = addrLi.find('.parcelItem:first').find('span.ordering_number').text() - 1;
    var length = addrLi.find('.parcelItem').length;
    var a = new Array();
    var n = 0;
    for (var i = start; i < start + length; i++) {
        var pd = $('#details').find('.parcelDetail').eq(i);
        a[n] = pd;
        n++;
    }
    for (var m = 0; m < a.length; m++){
        a[m].remove();
    }
    var count = $('#details').find('.parcelDetail').length;
    for (var n = 0; n < count; n++) {
        $('#details').find('.parcelDetail').eq(n).find('span:first').html(n + 1);
    }

    recalcAll();
}

function selectAddr() {
    var addrLi = $(this).closest('li');
    $('#dialog-addrs').dialog({
        modal: true,
        width: 600,
        height: 400,
        buttons: {
            "选择": function() {
                $( this ).dialog( "close" );
                if($('#dialog-addrs').find('.recv_addr:checked').length==0)
                    return;
                var select_id = $('#dialog-addrs').find('.recv_addr:checked').val(),
                    addr = recv_addr_dict[select_id];
                addrLi.find('[id$=name]').val(addr[0]);
                addrLi.find('[id$=street]').val(addr[1]);
                addrLi.find('[id$=street2]').val(addr[2]);
                addrLi.find('[id$=street3]').val(addr[3]);
                addrLi.find('[id$=city]').val(addr[4]);
                addrLi.find('[id$=postcode]').val(addr[5]);
                addrLi.find('[id$=phone]').val(addr[6]);
            },
            "取消": function() {
                $( this ).dialog( "close" );
            }
        }
    });
}

function smart_split(str, len)
{
    var arr = str.split(' ');
    var arr2 = ['', '', ''], j = 0;
    var sep = '';

    if(str.length-2 < len*3)
        sep = ' ';

    for(var i=0;i<arr.length;i++){
        if( (arr2[j]+sep+arr[i]).length <= len || j == 2)
            if(arr2[j] == '')
                arr2[j] += arr[i];
            else
                arr2[j] += sep+arr[i];
        else
            if(j < 2){
                j += 1;
                i -= 1;
            }
            else
                break;
    }

    return arr2;
}

function transPinyin() {
    var addrLi = $(this).closest('li');
    $('#dialog-pinyin').dialog({
        modal: true,
        width: 800,
        height: 500,
        buttons: {
            "翻译为拼音": function() {
                $.each(['py_name', 'py_city', 'py_zip', 'py_phone', 'py_street'], function(i, s){
                   $.get('/pinyin/', {'s': $('#'+s).val()}, function(s2){
                       if(s == 'py_street'){
                           $('#py2_street1').val(smart_split(s2, 24)[0]);
                           $('#py2_street2').val(smart_split(s2, 24)[1]);
                           $('#py2_street3').val(smart_split(s2, 24)[2]);
                       }
                       else
                            $('#'+s.replace('py_', 'py2_')).val(s2);
                    });
                });
            },
            "确定": function() {
                $( this ).dialog( "close" );
                addrLi.find('[id$=name]').val($('#py2_name').val());
                addrLi.find('[id$=street]').val($('#py2_street1').val());
                addrLi.find('[id$=street2]').val($('#py2_street2').val());
                addrLi.find('[id$=street3]').val($('#py2_street3').val());
                addrLi.find('[id$=city]').val($('#py2_city').val());
                addrLi.find('[id$=postcode]').val($('#py2_zip').val());
                addrLi.find('[id$=phone]').val($('#py2_phone').val());
            },
            "取消": function() {
                $( this ).dialog( "close" );
            }
        }
    });
}

function delParcel() {
    if ($('#id_parcel-TOTAL_FORMS').val() == 1)
        return;
    if($(this).closest('.addrItem').find('.parcelItem').length <= 1)
        return;
    var parcelLi = $(this).closest('li');
    var i = parcelLi.find('span.ordering_number').text();
    parcelLi.remove();
    updateParcels();

    var pd = $('#details').find('.parcelDetail').eq(i - 1);
    pd.remove();

    var count = $('#details').find('.parcelDetail').length;
    for (var n = 0; n < count; n++) {
        $('#details').find('.parcelDetail').eq(n).find('span:first').html(n + 1);
    }

    recalcAll();
}

function recalcAll() {
    var total = 0;
    var count = $('#details').find('.parcelDetail').length;
    for (var i = 0; i < count; i++) {
        var p = $('#details').find('.parcelDetail').eq(i);
        var cost = parseFloat(p.find('span.cost').text().substring(1));//去掉£
        var discount = parseFloat(p.find('span.discount').text().substring(1));
        total += cost - discount;
    }
    total = decimal(total, 2);

    var pickup;
    if ($('strong#service').text().indexOf('诚信物流取件') > 0) {
        if (count >= 3) {
            $('#pickup_price').text('£0.00');
            pickup = 0.0;
        }
        else {
            $('#pickup_price').text('£' + (2.0 * count));
            pickup = 2.0 * count;
        }
    }
    else {
        pickup = 0.0;
    }
   
    $('#total').html('£' + (total + pickup).toFixed(2));
}

function decimal(num, v) {
    var vv = Math.pow(10, v);
    return Math.round(num * vv) / vv;
}

function recalc() {
    var parcelLi = $(this).closest('li');
    var nan = parcelLi.find('.input-small').not(':first').is(function(){
        return isNaN(parseFloat($(this).val()));
    });

    $.ajax({
        //要用post方式       
        type: "Post",
        //方法所在页面和方法名       
        url: "Product.aspx/GetOrderPrice",
        data: "{'sid':'" + GetQueryString("serviceId") + "','index':'" + parcelLi.find('.ordering_number').text() + "','weight':'" + parcelLi.find('[id$=weight]').val() + "','length':'" + parcelLi.find('[id$=length]').val() + "','width':'" + parcelLi.find('[id$=width]').val() + "','height':'" + parcelLi.find('[id$=height]').val() + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (res) {
            var i = parcelLi.find('.ordering_number').text();
            var pd = $('#details').find('.parcelDetail').eq(i - 1);
            pd.find('span.cost').html('£' + res.d);
            recalcAll();
        },
        error: function (err) {
            alert('重量不能大于30KG，长宽高不能超过105CM。');
        }
    });
    // If at least one input not a number, return without posting to server
    if (nan)
        return;    
}

function GetQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}

$.fn.bindAllListners = function() {
    this.on('click', '.add-addr', addAddr);
    this.on('click', '.add-parcel', addParcel);
    this.on('click', '.clone', clone);
    this.on('change', '.input-small', recalc);
    this.on('click', '.del-addr', delAddr);
    this.on('click', '.del-parcel', delParcel);
    this.on('click', '.select-addr', selectAddr);
    this.on('click', '.trans-pinyin', transPinyin);
    this.on('change', '.addr_insurance', recalcAll);
    this.on('click', '#id_setDefalutSender', setDefalutSender);
}

function setDefalutSender(){
    $.ajax({        
        type: "Post",       
        url: "Product.aspx/SetDefaultSender",
        data: "{'username':'" + $('#id_username').text() + "','senderName':'" + $('#id_billing_detail_name').val() + "','city':'" + $('#id_billing_detail_city').val() + "','zipcode':'" + $('#id_billing_detail_postcode').val() + "','address1':'" + $('#id_billing_detail_street').val() + "','address2':'" + $('#id_billing_detail_street2').val() + "','address3':'" + $('#id_billing_detail_street3').val() + "','phone':'" + $('#id_billing_detail_phone').val() + "','mail':'" + $('#id_billing_detail_email').val() + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (res) {
            
        },
        error: function (err) {
            //alert('');
        }
    });
}

function clone() {
    var parcelLi = $(this).closest('li');
    var newLi = $(parcelLi).clone(true);
    newLi.find('.mx').not(':first').remove();
    newLi.find('[id$=TOTAL_FORMS]').val(1);
    newLi.find('input[type="text"]').filter(function(){return $(this).closest('.mx_cal').length}).val('');
    newLi.find('.mx_total').html('0');
    parcelLi.parent().append(newLi);
    updateParcels();

    var i = parcelLi.find('span.ordering_number').text();
    var pr = $('#details').find('.parcelDetail').eq(i - 1);
    var pd = pr.clone();
    var j = newLi.find('span.ordering_number').text();
    var pn = $('#details').find('.parcelDetail').eq(j - 2);
    pn.after(pd);
    var count = $('#details').find('.parcelDetail').length;
    //pd.find('span:first').html(i);
    for (var n = 0; n < count; n++) {
        $('#details').find('.parcelDetail').eq(n).find('span:first').html(n + 1);
    }

    recalcAll();

    /*
    var count = $('#details').find('.parcelDetail').length;
    pd.find('span:first').html(count);
    var pickup;
    if ($('strong#service').text().indexOf('诚信物流取件') > 0) {
        if (count >= 3) {
            $('#pickup_price').text('£0.00');
            pickup = 0.0;
        }
        else {
            $('#pickup_price').text('£' + (2.0 * count));
            pickup = 2.0 * count;
        }
    }
    else {
        pickup = 0.0;
    }
   
    var cost = parseFloat(pd.find('span.cost').text().substring(1));
    var discount = parseFloat(pd.find('span.discount').text().substring(1));
    $('#total').html('£' + ((cost - discount) * count + pickup));*/
}

function getOrderPrice(){
    var recipientCount = $('addr-TOTAL_FORMS').val();

}

function getParcelPrice()
{

}

$(function(){
    //~ require_template('addr');
    //~ require_template('parcel');
    $("#root").bindAllListners();

    //~ $('.con').sortable(sortable_option);
    $('.ordering').css('cursor', 'default');

    // Update the counts and indices cached by browser when user go back and forth.
    updateAddrs();
    //~ recalcAll();
});
