$(document).ready(function() {
    // make an ajax call to the generate_url_friendly_string resource and update the title_for_url
    // field with the html response
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