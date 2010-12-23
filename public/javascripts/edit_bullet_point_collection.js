$(document).ready(function() {
    $.clone_bp_count = 1;

    init_clone_bp_form();
    init_bp_removal();

    function init_clone_bp_form() {
        $('a#add_new_bp').parent().removeClass('hidden');
        $('a#add_new_bp').click(function(){
            try {
                // New Bullet Point:
                // 1. clone the container holding our bp elements
                // 2. update attributes/input
                // 3. append the newly updated bp container #bullet_pointsC
                var clone = $('div.bpC:last').clone();
                $('div.deleteC', clone).remove();
                $('input', clone).attr({
                    id   : 'new_bp_'+ $.clone_bp_count +'_content',
                    name : 'new_bp['+ $.clone_bp_count +'][content]'
                }).val('');
                $('#bullet_pointsC').append(clone);

                // I don't know of a good way to test if we are using a modal or not, so for now...ugly wins
                try { $.modal.impl.updateDimensionsAfterAppend(clone); } catch(ex){}

                $.clone_bp_count++;

                return false;
            } catch(e) { return true; } // go to the normal add bp form page
        });
    }
    
    function init_bp_removal() {
        $('a.bp_delete').each(function(){
            $(this).parent().removeClass('hidden');
            $(this).click(function(){
                var bpc = $(this).parents('.bpC');
                var id = $(this).attr('data-id');
                $.ajax({
                    url     : $(this).attr('href'),
                    dataType: 'html',
                    type    : $(this).attr('data-method'),
                    success: function (data, status, xhr) {
                        bpc.remove();
                        $('li#about_'+ id).fadeOut();
                        try {$.modal.impl.updateDimensionsAfterRemoval(bpc);}catch(e){}
                    },
                    error: function (xhr, status, error) {
                        $.Growl.show({
                          message : "#{standard_oops_message('bullet point')}",
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