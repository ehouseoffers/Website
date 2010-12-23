$(document).ready(function() {
    $('input[data-example]').tooltip({
      eventTrigger : 'focus',
      content      : 'data-example'
    });


    // What a mess. clean this up!
    var city_stateC = $('div#city_stateC');
    var city = $('input#seller_listing_address_city', city_stateC);
    var state = $('input#seller_listing_address_state', city_stateC);
    var zip = $('input#seller_listing_address_zip');

    function update_city_state(submit_form) {
      // If we don't have a zip to key off of, then we can't do anything
      if ( !zip.valid() ) return;

      // If we have both the city and state already in place, don't go replacing the values as the user may have
      // updated them manually after the first zip blur action
      if ( city.valid() && state.valid() ) return;

      $.ajax({
        url     : $.placefinder_by_zip_path,
        data    : 'zip='+ zip.val(),
        dataType: 'json',
        type    : 'GET',
        success: function (data, status, xhr) {
          // do not replace existing values
          if ( $.blank(city.val()) ) city.val(data['city']).trigger('blur');
          if ( $.blank(state.val()) ) state.val(data['state']).trigger('blur');

          // show the new fields
          city_stateC.removeClass('hidden').addClass('clearfix');

          if ( submit_form ) {
            // true if we hit submit from the zip field
            $('form#new_seller_listing').trigger('submit');
          } else {
            // trigger blur on each element so we get the validations
            city.trigger('blur');
            state.trigger('blur');
          }
        },
        error: function (xhr, status, error) {
          zip.val(zip.attr('data-example')).removeClass('valid').addClass('invalid');
          $('div.form_validation_icon', $('div#address_zip')).removeClass('valid').addClass('invalid');

          $.Growl.show({
            message : xhr.responseText,
            icon    : 'error',
            timeout : 7500
          });
        }
      });
    }

    // Always try to update the city/state when we leave the zip field. Let update_city_state() decide whether
    // we should make the placefinder call or not.
    zip.blur(function(event){
      update_city_state(false);
    });

    // Try to submit the form by hitting enter from the zip field? Keydown is called before blur so there should
    // not be a race condition here. Just make sure that update_city_state knows to submit the form once the ajax
    // call is complete
    zip.keydown(function(event){
      if ( event.keyCode == 13 ){
        update_city_state(true);
        return false;
      }
    });
  });

