$.fn.smart_toggle = function(opts) {
  var defaults = $.fn.smart_toggle.opts;

  // Allow for just a callback to be provided or extend opts
  opts = opts && $.isFunction(opts) ? (defaults.callback = opts, defaults) : $.extend(defaults, opts);

  // Chainability
  return this.bind('click', function() {
    var t = $($(this).attr('data-target'));
    if ( t.css('display')=='none' ) {
      t.show(opts.transition);
    } else {
      t.hide(opts.transition);
    }
    return false;
  });
};
$.fn.smart_toggle.opts = {
  replace_text : false,
  transition   : 'blind',
  callback     : function(){}
};
