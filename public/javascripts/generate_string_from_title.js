$(document).ready(function() {
    $('a#generate_string').click(function(){
        var title = $('input#reason_to_sell_title').val();
        if ( $.present(title) ) {
            var url = $(this).attr('href');
            $.get(url, 'string='+ title, function(resp) {
                $('input#reason_to_sell_title_for_url').val(resp);
            });

        } else {
            $.Growl.show({
                message : "The 'URL Friendly Title' is generated from the title. Please add a title then try again.",
                icon    : 'error',
                timeout : 5000
            });
        }
        return false; 
    });
});