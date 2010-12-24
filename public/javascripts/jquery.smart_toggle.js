$.fn.smart_toggle = function(args) {
    var defaults = $.fn.smart_toggle.opts;

    // Allow for just a callback to be provided or extend opts
    if ( args && $.isFunction(args) ) args.callback = args;

    var opts = {};
    $.extend(opts, $.fn.smart_toggle.opts, args);

    // Chainability
    return this.bind('click', function() {
        var target = $($(this).attr('data-target'));
        if ( target.size()==0 ) throw("no target found");

        var trigger = this;
        if ( !target.data('transition') ) {
            target.data('transition', true);
            
            if ( target.css('display')=='none' ) {
                target.show(opts.transition, function(){
                    if ( $.isFunction(opts.callback) ) opts.callback(trigger, target);
                    target.data('transition', false);
                });
            } else {
                target.hide(opts.transition, function(){
                    if ( $.isFunction(opts.callback) ) opts.callback(trigger, target);
                    target.data('transition', false);
                });
            }
        }
        return false;
  });
};
$.fn.smart_toggle.opts = {
    transition   : 'blind',
    callback     : null
};
