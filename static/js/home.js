function add_address(prefix, context)
{
    context = context || $('.formset');
    for(var i=0;i<100;i++)
        $('.packet', context).removeClass('addr_'+i);
    $('.packet', context).formset({
        context: context,
        prefix: prefix,
        formCssClass: prefix,
        addCssClass: 'add_pkt',
        addButtonCssClass: 'add_pkt',
        deleteCssClass: 'del_pkt',
        added: function(row){
            $('.' + prefix).each(function(index){
                $(this).find('.num').html(index+1);
            });
        },
        removed: function(row){
            $('.' + prefix).each(function(index){
                $(this).find('.num').html(index+1);
            });
        }
    });
}

$(function() {
    $('.pane1').on('click', '.add_addr', function(){
        var formset = $(this).closest('.formset'),
            template = formset.clone();
        template.find('.packet').not(':first').remove();
        template.find('.attr input').val('');
        template.find('.pkt-err').remove();
        template.clone().insertAfter($('.formset:last'));
        $('.formset').each(function(index){
            $(this).find('.addr_num').html(index+1);
            $(this).find('button').unbind();
            $(this).find('input').each(function(){
                $(this).attr('name', $(this).attr('name').replace(/addr_\d+/, 'addr_'+index));
            });
            var pkt_len = $(this).find('.packet').length;
            $(this).find('input[name="addr_'+index+'-TOTAL_FORMS"]').val(pkt_len);
            add_address('addr_'+index, $(this));
        });
        return false;
    });
    $('.pane1').on('click', '.del_addr', function(){
        if($('.pane1 .del_addr').length == 1)
            return false;
        $(this).closest('.formset').remove();
        $('.formset').each(function(index){
            $(this).find('.addr_num').html(index+1);
            $(this).find('button').unbind();
            $(this).find('input').each(function(){
                $(this).attr('name', $(this).attr('name').replace(/addr_\d+/, 'addr_'+index));
            });
            add_address('addr_'+index, $(this));
        });
        return false;
    });
});
