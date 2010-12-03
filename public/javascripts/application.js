$(document).ready(function() {
    if ( $('form').length > 0 ) {
      // B/c it can take some time to load an external file so you can’t always run functions from within that file
      // straight away
      $.ajaxSetup({async: false});
      $.load_external_resource('jquery.ketchup.js,jquery.default_values.js');
      $.ajaxSetup({async: true});

      var error_timeout = $.ketchup_default_error_timeout;
      $('form').ketchup({
        validationAttribute : 'data-validation',
        errorTimeout  : error_timeout,
        hideContainer : function(){},
        showContainer : function(err){
          $.Growl.show({
            message : err.html(),
            icon    : 'error',
            timeout : error_timeout
          });
          setTimeout(function(){ $.visibleContainer = false; }, error_timeout);
        }})
      .default_form_values();
    }

    var modals = $('.uso_modal');
    if ( modals.length > 0 )
        $.load_external_resource('jquery.modal.js,jquery.modal.css');


    $('.uso_modal').click(function(){
        var resource = $(this).attr('data-resource');

        $.get($(this).attr('href'), function(resp){
            $.load_external_resource(resource,{skip:'js'});

            $.modal(resp, {
                minWidth : 730, /* for collection edit form */
                maxHeight: 500,
                onOpen : function (dialog) {
                    $.load_external_resource(resource,{skip:'css'});
                    dialog.overlay.fadeIn('slow', function () {
                        dialog.container.slideDown('slow', function () {
                            dialog.data.fadeIn('slow');
                        });
                    });
                },
                onClose : function (dialog) {
                    dialog.data.fadeOut('slow', function () {
                        $.remove_external_resource(resource);

                        dialog.container.slideUp('slow', function () {
                            dialog.overlay.fadeOut('slow', function () {
                                $.modal.close(); // must call this!
                            });
                        });
                    });
                }
            });
        });
        return false;
    });
});

//
// Common Site Tools
//
jQuery.extend(jQuery, {
    blank   : function(string) { return !$.present(string); },
    present : function(string) { return $.trim(string).length>0; },

    // HTML Encode -- trying to keep it similar to rail's h()
    h : function(string) {
        return $(document.createElement('span')).text(string).html();
    },

    preserve_newlines : function(string) {
        return $.h(string).replace(/\n/gi, '<br />');
    },

    // Take what we think is a function, check to make sure it is and call it
    // if we can returning the functions return value or false otherwise
    call_fn : function(fn, args) {
        if ( jQuery.isFunction(fn) ) return fn(args);
    }
    
});


//
// External Resource Manager :: add/remove js/css files
//
jQuery.extend(jQuery, {
    load_external_resource : function(resource,options) {
        try {
			var o = $.extend({}, {skip:null}, options);

            if ( !$.present(resource) ) return;

            if ( resource.match(/,/) ) {
                $.each(resource.split(','), function(index,r){
                    $.load_external_resource($.trim(r));
                });
                return;
            }

            resource = $.standardize_resource(resource);

            // Only load a resource once
            if ( $.data(document.body, resource) ) return;
            $.data(document.body, resource, true);

            if ( $.js_resource(resource) && o['skip'] != 'js') {
                jQuery.getScript(resource);

            } else if ( $.standardize_resource(resource) && o['skip'] != 'css') {
                // IE -- http://stackoverflow.com/questions/1184950/dynamically-loading-css-stylesheet-doesnt-work-on-ie
                if ( document.createStyleSheet ) {
                    document.createStyleSheet(resource);
                } else {
                    var file_obj = $(document.createElement('link')).attr({
                        type  : 'text/css',
                        rel   : 'stylesheet',
                        media : 'screen',
                        href  : resource
                    });
                    $('head').append(file_obj);
                }
            }

        } catch(e) {
            console.log(e);
        }
    },

    remove_external_resource : function(resource) {
        try {
            if ( !$.present(resource) ) return;

            if ( resource.match(/,/) ) {
                $.each(resource.split(','), function(index,r){
                    $.remove_external_resource($.trim(r));
                });
                return;
            }

            resource = $.standardize_resource(resource);
            if ( $.js_resource(resource) ) {
                $('script[src="'+ resource +'"]').remove();
            } else if ( resource.match(/\.css$/) ) {
                $('link[href="'+ resource +'"]').remove();
            }
            $.data(document.body, resource, false);

        } catch(e) {}
    },

    js_resource  : function(r) { return r.match(/\.js$/)!=null; },
    css_resource : function(r) { return r.match(/\.css$/)!=null; },

    // if we pass something without a '/' in it, assume it is one of our js/css files
    standardize_resource : function(r) {
        if ( $.js_resource(r) ) {
            return r.match(/\//) ? r : '/javascripts/'+ r;
        } else if ( $.css_resource(r) ) {
            return r.match(/\//) ? r : '/stylesheets/'+ r;
        }
    },

});