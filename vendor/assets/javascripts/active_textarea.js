	jQuery(document).ready(function() {
		
		jQuery('#submit_msg').click(function() {
			
			var text_title = this.form.message_body.value;
			if(text_title.trim() != ''){
				$("#reply_message").submit();
				$("#message_body").val('');
				$(".content").mCustomScrollbar("scrollTo", "bottom");
			}
		});

    	jQuery("#message_body").keyup(function (e) {

        var code = (e.keyCode ? e.keyCode : e.which);
        
        var text_title = this.form.message_body.value;
	      
		   if(text_title.trim() != ''){

		      jQuery('input[type="button"]').addClass('msg_active');

		      if (code == 13) {
	        	$("#reply_message").submit();
	        	$("#message_body").val('');	
	        	$(".content").mCustomScrollbar("scrollTo", "bottom");
	            return true;
	         }
		   } 
		   if(text_title == '')
			{
				jQuery('input[type="button"]').removeClass('msg_active');
			}

		});

    	
	});