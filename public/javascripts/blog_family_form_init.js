$(document).ready(function() {
    // $('form').ketchup().default_form_values();

    $('a#generate_string').click(function(){
        var title = $('input#blog_title').val();
        if ( $.present(title) ) {
            var url = $(this).attr('href');
            $.get(url, 'string='+ title, function(resp) {
                $('input#title_for_url').val(resp);
            });

        } else {
            $.Growl.show({
                message : "The 'SEO Friendly Title' is generated from the title. Please add a title then try again.",
                icon    : 'error',
                timeout : 5000
            });
        }
        return false; 
    });
});