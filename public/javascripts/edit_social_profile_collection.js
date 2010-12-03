$(document).ready(function() {
    $.clone_sp_count = 1;
    init_clone_sp_form();
    init_sp_removal();

    function init_clone_sp_form() {
        $('div#add_new_spC').removeClass('hidden');
        $('a#add_new_sp').click(function(){
            try {
                var clone = $('tr.scC:last').clone();

                // Website Selection
                var sel = $('select', clone);
                sel.attr({
                    id   : 'new_sp_'+ $.clone_sp_count +'_website',
                    name : 'new_sp['+ $.clone_sp_count +'][website]'
                });
                $('option:first', sel).attr('selected','selected');

                // Username input
                $('input.username', clone).attr({
                    id   : 'new_sp_'+ $.clone_sp_count +'_username',
                    name : 'new_sp['+ $.clone_sp_count +'][username]'
                }).val('');

                // URL input
                $('input.url', clone).attr({
                    id   : 'new_sp_'+ $.clone_sp_count +'_url',
                    name : 'new_sp['+ $.clone_sp_count +'][url]'
                }).val('');

                $('a.sp_delete', clone).remove();

                $('table#edit_sp_collection').append(clone)

                // Setup for the next new QA
                $.clone_sp_count++;

                try { $.modal.impl.updateDimensionsAfterAppend(clone); }catch(e){}

               return false;

           } catch(e) { return true }
        });
    }
    
    function init_sp_removal() {
        $('a.sp_delete').each(function(){
            $(this).removeClass('hidden');
            $(this).click(function(){
                var id = $(this).attr('data-id');
                $.ajax({
                    url     : $(this).attr('href'),
                    dataType: 'html',
                    type    : $(this).attr('data-method'),
                    success: function (data, status, xhr) {
                        $('tr#sp_'+ id).fadeOut();
                        $('li#sp_'+ id).fadeOut();
                    },
                    error: function (xhr, status, error) {
                        $.Growl.show({
                          message : "#{standard_oops_message('social profile')}",
                          icon    : 'error',
                          timeout : 7500
                        });
                    }
                });

               return false; 
            });
        });
    }
});