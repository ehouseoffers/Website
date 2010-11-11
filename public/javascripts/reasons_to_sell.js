$(document).ready(function() {
    $('form.email_image_form').ketchup().default_form_values();

    $('.copy_image_code').click(function(e){
        $(this).select();
        return false;
    })
});
