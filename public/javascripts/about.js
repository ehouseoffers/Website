$(document).ready(function() {
    var trigger = $('a#tos_view_trigger');
    var list = $('div#tos_veil');

    // Show tos onload?
    if ( window.location.hash == '#tos' ) {
        trigger.html('Hide Terms of Service');
        list.removeClass('hidden');
    }

    // Setup tos show/hide toggle for both the trigger in the page as well as the footer tos link
    $('a#footer_tos_link, a#tos_view_trigger').click(function(){
        if ( list.hasClass('hidden') ) {
            trigger.html('Hide Terms of Service');
            list.removeClass('hidden');
        } else {
            trigger.html('Show Terms of Service');
            list.addClass('hidden');
        }

    });
});