$(document).ready(function() {
    $('#ec_button').smart_toggle(function(trigger, target){
        $(trigger).toggleClass('expand contract');
    });
});