$(document).ready(function() {
    // email_this_image widget
    $('form.email_image_form').submit(function(e){
        // Check with jquery.ketchup's validation results first
        if ( !$.data(e,'passed_validations') ) return;

        var rc = $('.js_reportC', this);
        var f = $(this);
        $.ajax({
            url     : f.attr('action'),
            type    : f.attr('method'),
            data    : f.serialize(),
            dataType: 'json',
            success : function (data, status, xhr) {
                rc.html('Thank you! This image has been emailed.').fadeIn();
                setTimeout(function(){ rc.fadeOut(); }, 5000);
            },
            error: function (xhr, status, error) {
                rc.html('An error occured.Please try again later or email us directly at <a href="mailto:info@ehouseoffers.com">info@ehouseoffers.com</a>').fadeIn();
            }
        });
        return false;
    });

    // Share This Image widget: highlight the contents of the box when clicked on
    $('.copy_image_code').click(function(e){
        $(this).select();
        return false;
    })
});