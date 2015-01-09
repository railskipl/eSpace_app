  jQuery(function($){
    $("#post_pick_up_avaibilty_start_date").datepicker({dateFormat: 'M d,yy',changeMonth: false,changeYear: false, minDate: 0, showOn: 'button', buttonImage: '/assets/cal_icon2.png', buttonImageOnly: true, buttontabindex: true})
  });
  jQuery(function($){
    $("#post_pick_up_avaibility_end_date").datepicker({dateFormat: 'M d,yy',changeMonth: false,changeYear: false, minDate: 0, showOn: 'button', buttonImage: '/assets/cal_icon2.png', buttonImageOnly: true})
  });
  jQuery(function($){
    $("#post_drop_off_avaibility_start_date").datepicker({dateFormat: 'M d,yy',changeMonth: false,changeYear: false, minDate: 0, showOn: 'button', buttonImage: '/assets/cal_icon2.png', buttonImageOnly: true, buttontabindex: true})
  });
  jQuery(function($){
    $("#post_drop_off_avaibility_end_date").datepicker({dateFormat: 'M d,yy',changeMonth: false,changeYear: false, minDate: 0, showOn: 'button', buttonImage: '/assets/cal_icon2.png', buttonImageOnly: true})
  });
    
  $(document).ready(function(){
      $('input[type="checkbox"]').click(function(){
          if($(this).attr("id")=="post_pick_up"){
              $(".post_pick_up").toggle();
          }
          if($(this).attr("id")=="post_drop_off"){
              $(".post_drop_off").toggle();
          }
          
      });
  });

