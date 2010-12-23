$.fn.tooltip = function(opts) {
    this.each(function() { new ToolTip(this, opts); });
    
    // chainability
    return this;
};


var ToolTip = function(el, opts) { this.init(el,opts); };
jQuery.extend(ToolTip.prototype, {
    init : function(trigger,opts) {
        this.trigger = $(trigger);

        this.opts = {};
        $.extend(this.opts, $.fn.tooltip.opts, opts);

        if ( $.isFunction(this.opts.exclude) && !this.opts.exclude(this) ) {
            this.tt = {};
            this.tt.id = 'tooltip-'+ $.tooltip_count++;
            this.tt.content = this._fetch_content();
            if ( this.tt.content ) this._bind_to();
            return this;
        }
    },

    show : function(){
        // no tooltip? Hmm, then we called this from our event trigger (i.e. _bind_to_mouseover). If that is the case,
        // then we need to trigger our trigger event in order to get everything created and positioned properly
        if ( !this.tooltip ) this.trigger.trigger('mouseover');
        else this.tooltip.fadeIn(this.opts.speed);
    },

    remove : function() {
        if ( this.tooltip ) this.tooltip.fadeOut(this.opts.speed, function(){ $(this).remove(); });
    },

    //
    // PRIVATE-ish
    //
    _bind_to : function(){
        switch(this.opts.eventTrigger) {
            case 'mouseover' : this._bind_to_mouseover(); break;
            case 'focus' : this._bind_to_focus(); break;
        }
    },

    _bind_to_focus : function(){
        var self = this;
        this.trigger.focus(function(e) {
            self._attach_tooltip();
            self._position_tooltip(e);
            self.show();
        });
        this.trigger.blur(function(e) {
            self.remove();
        });

    },

    _bind_to_mouseover : function(){
        var self = this;
        this.trigger.mouseover(function(e) {
            self._attach_tooltip();
            self._position_tooltip(e);
            self.show();
        });
        this.trigger.mouseout(function(e) {
            self.remove();
        });
      
        // Tracking : available only on mouseover
        if ( this.opts.tracking )
            this.trigger.mousemove(function(e) { self._position_tooltip(e); });
    },

    // where to position the tooltip when the show/hide was bound to the mouseover event
    _position_tooltip : function(e) {
        if ( $.isFunction(this.opts.positionHandler) ) {
            this.opts.positionHandler(this,e);

        } else {
            var el = $(e.currentTarget);
            var offset = el.offset();
            this.tooltip.css({
                'left'  : ((offset.left - this.opts.xoffset) + "px"),
                'top'   : ((offset.top - this.opts.yoffset) + "px")
            });
        }
    },

    _fetch_content : function() {
        var c = '';
        // Get the content from...
        if ( this.opts.content.match(/^[\.#]/) ) {         // an element via a class or id selection
            c = $(this.opts.content).html();
        } else if ( this.opts.content.match(/^data-/) ) {  // the trigger element's data-* attribute
            c = this.trigger.attr(this.opts.content);
        } else if ( $.isFunction(this.opts.content) ) {
            this.opts.content(this);
        } else if ( $.trim(this.opts.content).length>0 ) { // whatever they gave us as this.content
            c = this.opts.content;
        }
        return $.trim(c).length>0 ? c : undefined;
    },

    _attach_tooltip : function() {
        var tail = $(document.createElement('span')).css({
            'display'     :'block',
            'width'       : '0',
            'height'      : '0',
            'borderLeft'  : '5px solid transparent',
            'borderRight' : '5px solid transparent',
            'borderTop'   : '10px solid '+ this.opts.css.background,
            'borderBottom': '0',
            'marginLeft'  : '10px'
        });
        var contentC = $(document.createElement('div')).css({
            'background'        : this.opts.css.background,
            'color'             : this.opts.css.color,
            'fontSize'          : this.opts.css.fontSize,
            'lineHeight'        : this.opts.css.lineHeight,
            'margin'            : this.opts.css.margin,
            'padding'           : this.opts.css.padding,
            'borderRadius'      : this.opts.css.borderRadius,
            'MozBorderRadius'   : this.opts.css.borderRadius,
            'WebkitBorderRadius': this.opts.css.borderRadius,
        }).html(this.tt.content);

        this.tooltip = $(document.createElement('div'))
        .attr({ id : this.tt.id })
        .css({ position:'absolute' });

        $('body').append(this.tooltip.append(contentC).append(tail));
    }
});


$.tooltip_count = 0;
$.fn.tooltip.opts = {
    xoffset  : 10,
    yoffset  : 35,
    positionHandler : null,
    speed        : 'fast',     // show/hide transition speed
    content      : 'data-tt',  // can be .class, #id, data-* attribute or string
    eventTrigger : 'mouseover',// this equates to hover, but hover is just syntactic sugar for mouseover/mouseout
    tracking     : true,       // available only on mouseover
    css : {
        borderRadius : '5px',
        background   : '#af526a',
        color        : '#ffffff',
        fontSize     : '12px',
        lineHeight   : '16px',
        padding      : '5px 10px',
        margin       : '0px'
    },
    exclude : function(tt){   // do we want to exclude a given trigger?
        // We only want to exclude if:
        // 1) this triggering element has a label attached to it and
        // 2) that label's display is either block or inline (that it is visible)

        // We need to use the parent form as the scope since the ids are not always unique
        var p = tt.trigger.parents('form');
        var l = $('label[for="'+ tt.trigger.attr('id') +'"]', p);
        return l.css('display').match(/^(block|inline)$/) != undefined;
    }
};
