 function get_drop_off_and_pick_date(drop_off_start_date, drop_off_end_date, pick_up_start_date, pick_up_end_date)
 {
  	  $("#booking_dropoff_date").datepicker({dateFormat: 'd M yy', showOn: 'button', buttonImage: '/assets/calendar_post.jpg', buttonImageOnly: true, minDate: new Date(drop_off_start_date), maxDate: new Date(drop_off_end_date)})
      $("#booking_pickup_date").datepicker({dateFormat: 'd M yy', showOn: 'button', buttonImage: '/assets/calendar_post.jpg', buttonImageOnly: true, minDate: new Date(pick_up_start_date), maxDate: new Date(pick_up_end_date)})
      jQuery('input').live('blur', function() {
            if (jQuery("#booking").valid()) {
              jQuery('#customButton').removeAttr('disabled');
            } else {
                jQuery('#customButton').attr('disabled', 'disabled');
            }
        });
 }