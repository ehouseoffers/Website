$(document).ready(function() {

    if ( $('form').length > 0 ) $('form').ketchup().default_form_values();

    var modals = $('.uso_modal');
    if ( modals.length > 0 ) {
        $.load_external_resource('/javascripts/jquery.modal.js');
        $.load_external_resource('/stylesheets/jquery.modal.css');
    }

    $('.uso_modal').click(function(){
        var resource = $(this).attr('data-resource');
        if ( $.present(resource) ) $.load_external_resource(resource);

        $.get($(this).attr('href'), function(resp){
            $.modal(resp, {
                onOpen : function (dialog) {
                    dialog.overlay.fadeIn('slow', function () {
                        dialog.container.slideDown('slow', function () {
                            dialog.data.fadeIn('slow');
                        });
                    });
                },
                onClose : function (dialog) {
                    dialog.data.fadeOut('slow', function () {
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
 
jQuery.extend(jQuery, {
    blank   : function(string) { return !$.present(string); },
    present : function(string) { return $.trim(string).length>0; },

    load_external_resource : function(resource) {
        try {
            var file_obj;
            if ( resource.match(/\.js$/) ) {
                file_obj = $(document.createElement('script')).attr({
                    type : 'text/javascript',
                    src  : resource
                });
            } else if ( resource.match(/\.css$/) ) {
                // IE -- http://stackoverflow.com/questions/1184950/dynamically-loading-css-stylesheet-doesnt-work-on-ie
                if ( document.createStyleSheet ) {
                    document.createStyleSheet(resource);
                } else {
                    file_obj = $(document.createElement('link')).attr({
                        type  : 'text/css',
                        rel   : 'stylesheet',
                        media : 'screen',
                        href  : resource
                    });
                }
            }
            if ( typeof file_obj != undefined ) $('head').append(file_obj);
        } catch(e) {
            alert(e);
        }
    },

    // HTML Encode -- trying to keep it similar to rail's h()
    h : function(string) {
        return $(document.createElement('span')).text(string).html();
    },

    preserve_newlines : function(string) {
        return $.h(string).replace(/\n/gi, '<br />');
    },

});
