$(document).ready(function() {
    var trigger = $('a#tos_view_trigger');
    console.log(trigger);
    var list = $('div#tos_veil');
    console.log(list);

    trigger.click(function(){
        if ( list.hasClass('hidden') ) {
            trigger.html('Hide Terms of Service');
            list.removeClass('hidden');
        } else {
            trigger.html('Show Terms of Service');
            list.addClass('hidden');
        }
        return false;
    });
});