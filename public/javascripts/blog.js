$(document).ready(function() {
    // email_this_image widget
    $('form.email_image_form').submit(function(){
        $.Growl.show({
            message : "Sorry, but this is not yet written. Take a look at blog.js for starters, then head over to blogs_controller.email_image. That is all",
            icon    : 'error',
            timeout : 5000
        });
        return false;
    })

    // Share This Image widget: highlight the contents of the box when clicked on
    $('.copy_image_code').click(function(e){
        $(this).select();
        return false;
    })

    // Blog Edit/New Forms Only:
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