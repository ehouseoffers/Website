/*
   jQuery Ketchup Plugin
   =====================
   Tasty Form Validation
   
   Version 0.1 - 12. Feb 2010
   
   Copyright (c) 2010 by Sebastian Senf:
   http://mustardamus.com/
   http://usejquery.com/
   
   Dual licensed under the MIT and GPL licenses:
   http://www.opensource.org/licenses/mit-license.php
   http://www.gnu.org/licenses/gpl.html
   
   Demo:            http://demos.usejquery.com/ketchup-plugin/
   Source:          http://github.com/mustardamus/ketchup-plugin

   younker [2010-10-29 10:44]
   All 3 files, jquery.ketchup.js, jquery.ketchup.messages.js and jquery.ketchup.validations.js, were put into
   This one file to reduce http requests on pageload
*/

//
// jquery.ketchup.js
//
(function($) {
  var validate = 'validate';
  
  
  function squeeze(form) {
    var fields = fieldsToValidate(form);
    
    for(var i = 0; i < fields.length; i++) {
      bindField(fields[i]);
    }

    
    form.submit(function() {
      var tasty = true;
      
      for(var i = 0; i < fields.length; i++) {
        if(buildErrorList(extractValidations(fields[i].blur()), fields[i]).length) tasty = false;
      }
      
      if(!tasty) return false;
    });
  }
  
  
  function fieldsToValidate(form) {
    var tags = 'input textarea select'.split(' ');
    var fields = [];
    
    for(var i = 0; i < tags.length; i++) {
      form.find(tags[i]+'['+options.validationAttribute+'*='+validate+']').each(function() {
        fields.push($(this));
      });
    }
    
    return fields;
  }
  
  
  function bindField(field) {
    var validations = extractValidations(field);
    var errorContainer = field.after(options.errorContainer.clone()).next();
    var contOl = errorContainer.find('ol');
    var visibleContainer = false;
    
    $(window).resize(function() {
      options.initialPositionContainer(errorContainer, field);
    }).trigger('resize');
    

    field.blur(function() {
      var errList = buildErrorList(validations, field);
  
      if(errList.length) {
        if(!visibleContainer) {
          contOl.html(errList);
          options.showContainer(errorContainer);
          visibleContainer = true;
        } else {
          contOl.html(errList);
        }
    
        options.positionContainer(errorContainer, field);
      } else {
        options.hideContainer(errorContainer);
        visibleContainer = false;
      }
    });


    if(field.attr('type') == 'checkbox') {
      field.change(function() { //chrome dont fire blur on checkboxes, but change
        $(this).blur(); //so just simulate a blur
      });
    }
  }
  
  
  function extractValidations(field) {
    var valStr = field.attr(options.validationAttribute);
        valStr = valStr.substr(valStr.indexOf(validate) + validate.length + 1);
    var validations = [];
    var tempStr = '';
    var openBrackets = 0;
    
    for(var i = 0; i < valStr.length; i++) {
      switch(valStr[i]) {
        case ',':
          if(openBrackets) {
            tempStr += ',';
          } else {
            validations.push(trim(tempStr));
            tempStr = '';
          }
          break;
        case '(':
          tempStr += '(';
          openBrackets++;
          break;
        case ')':
          if(openBrackets) {
            tempStr += ')';
            openBrackets--;
          } else {
            validations.push(trim(tempStr));
          }
          break;
        default:
          tempStr += valStr[i];
      }
    }

    return validations;    
  }
  
  
  function trim(str) {
    return str.replace(/^\s+/, '').replace(/\s+$/, '');
  }
  
  
  function getFunctionName(validation) {
    if(validation.indexOf('(') != -1) {
      return validation.substr(0, validation.indexOf('('));
    } else {
      return validation;
    }
  }
  
  
  function buildParams(validation) {
    if(validation.indexOf('(') != -1) {
      var arr = validation.substring(validation.indexOf('(') + 1, validation.length - 1).split(',');
      var tempStr = '';
      
      for(var i = 0; i < arr.length; i++) {
        var single = trim(arr[i]);
        
        if(parseInt(single)) {
          tempStr += ','+single;
        } else {
          tempStr += ',"'+single+'"'
        }
      }
      
      return tempStr;
    } else {
      return '';
    }
  }
  
  
  function formatMessage(message, params) {
    var args = message.split('$arg').length - 1;
    
    if(args) {
      var parArr = params.split(',');
      
      for(var i = 1; i < parArr.length; i++) {
        message = message.replace('$arg'+i, parArr[i]);
      }
    }
    
    return message;
  }
  
  
  function buildErrorList(validations, field) {
    var list = '';
    
    for(var i = 0; i < validations.length; i++) {
      var funcName = getFunctionName(validations[i]);
      var params = buildParams(validations[i]);
      
      if(!eval('$.fn.ketchup.validations["'+funcName+'"](field, field.val()'+params+')')) {
        list += '<li>'+formatMessage($.fn.ketchup.messages[funcName], params)+'</li>';
      } 
    }
    
    return list;
  }
  
  
  var errorContainer = $('<div>', {
    'class':  'ketchup-error-container',
    html:     '<ol></ol><span></span>'
  });
  
  
  var initialPositionContainer = function(errorContainer, field) {
    var fOffset = field.offset();

    errorContainer.css({
      left: fOffset.left + field.width() - 10,
      top: fOffset.top - errorContainer.height()
    });
  };
  
  
  var positionContainer = function(errorContainer, field) {
    errorContainer.animate({
      top: field.offset().top - errorContainer.height()
    });
  };
  
  
  var showContainer = function(errorContainer) {
    errorContainer.fadeIn();
  };
  
  
  var hideContainer = function(errorContainer) {
    errorContainer.fadeOut();
  };
  
  
  $.fn.ketchup = function(opt) {
    options = $.extend({}, $.fn.ketchup.defaults, opt);
    
    return this.each(function() {
      squeeze($(this));
    });
  };
  

  $.fn.ketchup.validation = function(name, func) {
    $.fn.ketchup.validations.push(name);
    $.fn.ketchup.validations[name] = func;
  };
  
  
  $.fn.ketchup.messages = {};
  $.fn.ketchup.validations = [];
  var options;

  $.fn.ketchup.defaults = {
    validateOnblur:           false,
    validationAttribute:      'class',
    errorContainer:           errorContainer,
    initialPositionContainer: initialPositionContainer,
    positionContainer:        positionContainer,
    showContainer:            showContainer,
    hideContainer:            hideContainer
  };
})(jQuery);


//
// jquery.ketchup.validations.basic
//
$.fn.ketchup.validation('required', function(element, value) {
  if(element.attr('type') == 'checkbox') {
    if(element.attr('checked') == true) return true;
    else return false;
  } else {
    if ( !eval($.fn.ketchup.validations['example'])(element, value) ) return false;
    else if(value.length==0) return false;
    else return true;
  }
});

$.fn.ketchup.validation('suggest', function(element, value) {
    // if we have already suggested this, don't do it again. this is a 1 time notice
    if ( element.data('suggested') ) return true;

    // Only show the suggestion message if the field does not have a valid value (which is really what required does)
    if ( $.fn.ketchup.validations['required'](element, value) ) return true;

    // use data cache to hold suggestion value for this element
    element.data('suggested', true);
    return false;
});

$.fn.ketchup.validation('example', function(element, value) {
    if ( value == element.attr('data-example') ) return false;
    else return true;
});

$.fn.ketchup.validation('minlength', function(element, value, minlength) {
  if(value.length < minlength) return false;
  else return true;
});

$.fn.ketchup.validation('maxlength', function(element, value, maxlength) {
  if(value.length > maxlength) return false;
  else return true;
});

$.fn.ketchup.validation('rangelength', function(element, value, minlength, maxlength) {
  if(value.length >= minlength && value.length <= maxlength) return true;
  else return false;
});


$.fn.ketchup.validation('min', function(element, value, min) {
  if(parseInt(value) < min) return false;
  else return true;
});

$.fn.ketchup.validation('max', function(element, value, max) {
  if(parseInt(value) > max) return false;
  else return true;
});

$.fn.ketchup.validation('range', function(element, value, min, max) {
  if(parseInt(value) >= min && parseInt(value) <= max) return true;
  else return false;
});


$.fn.ketchup.validation('number', function(element, value) {
  if(/^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/.test(value)) return true;
  else return false;
});

$.fn.ketchup.validation('digits', function(element, value) {
  if(/^\d+$/.test(value)) return true;
  else return false;
});


$.fn.ketchup.validation('email', function(element, value) {
  if(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i.test(value)) return true;
  else return false;
});


$.fn.ketchup.validation('url', function(element, value) {
  if(/^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(value)) return true;
  else return false;
});


$.fn.ketchup.validation('username', function(element, value) {
  if(/^([a-zA-Z])[a-zA-Z_-]*[\w_-]*[\S]$|^([a-zA-Z])[0-9_-]*[\S]$|^[a-zA-Z]*[\S]$/.test(value)) return true;
  else return false;
});


$.fn.ketchup.validation('match', function(element, value, match) {
  if($(match).val() != value) return false;
  else return true;
});


$.fn.ketchup.validation('date', function(element, value) {
  if(!/Invalid|NaN/.test(new Date(value))) return true;
  else return false;
});


function watchSelect(type) {
  $('input['+$.fn.ketchup.defaults.validationAttribute+'*="'+type+'"]').each(function() {
    var el = $(this);

    $('input[name="'+el.attr('name')+'"]').each(function() {
      var al = $(this);
      if(al.attr($.fn.ketchup.defaults.validationAttribute).indexOf(type) == -1) al.blur(function() { el.blur(); });
    });
  });
}

$(document).ready(function() {
  watchSelect('minselect');
  watchSelect('maxselect');
  watchSelect('rangeselect');
});

$.fn.ketchup.validation('minselect', function(element, value, min) {
  if($('input[name="'+element.attr('name')+'"]:checked').length >= min) return true;
  else return false;
});

$.fn.ketchup.validation('maxselect', function(element, value, max) {
  if($('input[name="'+element.attr('name')+'"]:checked').length <= max) return true;
  else return false;
});

$.fn.ketchup.validation('rangeselect', function(element, value, min, max) {
  var checked = $('input[name="'+element.attr('name')+'"]:checked');
  
  if(checked.length >= min && checked.length <= max) return true;
  else return false;
});


//
// jquery.ketchup.messages.js
//
$.fn.ketchup.messages = {
  'required':     'This field is required.',
  'minlength':    'This field must have a minimal length of $arg1.',
  'maxlength':    'This field must have a maximal length of $arg1.',
  'rangelength':  'This field must have a length between $arg1 and $arg2.',
  'min':          'Must be at least $arg1.',
  'max':          'Can not be greater than $arg1.',
  'range':        'Must be between $arg1 and $arg2.',
  'number':       'Must be a number.',
  'digits':       'Must be digits.',
  'email':        'Must be a valid E-Mail.',
  'url':          'Must be a valid URL.',
  'username':     'Must be a valid username.',
  'match':        'Must match the field above.',
  'date':         'Must be a valid date.',
  'minselect':    'Select at least $arg1 checkboxes.',
  'maxselect':    'Select not more than $arg1 checkboxes.',
  'rangeselect':  'Select between $arg1 and $arg2 checkboxes.',
  'notExample':   'This field\'s value cannot match the example',
  'suggest':      'Please enter a value for this field'
};
