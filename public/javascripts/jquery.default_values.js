(function($) {
  $.fn.default_form_values = function(opt) {
      var objects = [];
      var fields = $(this).find("input[data-example], select[data-example], textarea[data-example]").not(":submit, :hidden");

      fields.each(function(idx, input_field){
          objects[idx] = new DefaultFormValue($(input_field));
      });

      $(this).submit(function(){
          // $.each(objects, function() {
          //     var s = this;
          //     if ( this._input_requires_example() ) {
          //         var v = this.input.val('');
          //         setTimeout(function(){s._insert_examples_callback(s)}, 2500);
          //     }
          // });
      });

      // For chainability sake, return this rather than the objects
      return this;
  }

  // right now is pretty much only for input fields. textareas will bomb!
  $.fn.valid = function() {
      var el = $(this);
      return (el.val() && $.trim(el.val())!='' && el.val() != $(el).attr('data-example'))==true;
  }

})(jQuery);

var DefaultFormValue = function(input) { this.init(input); };
jQuery.extend(DefaultFormValue.prototype, {
    init : function(input) {
        this.input   = input;
        this.example = $(input).attr('data-example');

        if ( $.present(this.example) ) {
          // Update input with default value (assume it is empty onload for non-js users)
          this._onblur();

          var self = this;
          input.focus(function(){ self._onfocus(); }).blur(function(){ self._onblur(); });
        }
    },
    _onfocus : function(){
        if ( this._clear_input_if() ) this.input.css('color','inherit');
    },
    _onblur : function(){
        if ( this._insert_example_if() ) this.input.css('color','#b1b1b1');
    },
    _clear_input_if : function(){
        if ( this.example == this.input.val() ) {
            this.input.val('');
            return true;
        }
        return false;
    },
    _insert_example_if : function() {
        if ( this._input_requires_example() ) {
            this.input.val(this.example);
            return true;
        }
        return false;
    },
    _input_requires_example : function() {
        return !this.input.valid();
    },
    _insert_examples_callback : function(default_form_value_object) {
        default_form_value_object._insert_example_if();
    }
});

