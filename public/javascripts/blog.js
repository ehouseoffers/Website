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
});