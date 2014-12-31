jQuery.validator.addMethod("greaterThan", 
function(value, element, params) {

    if (!/Invalid|NaN/.test(new Date(value))) {
        return new Date(value) > new Date($(params).val());
    }

    return isNaN(value) && isNaN($(params).val()) 
        || (Number(value) > Number($(params).val())); 
},'Must be greater than Start date.');

//User not select next drop off date
jQuery.validator.addMethod("lessThanDropDate", 
	function(value, element, params) {

	    if (!/Invalid|NaN/.test(new Date(value))) {
	        return new Date(value) < new Date($(params).val());
	    }

	    return isNaN(value) && isNaN($(params).val()) 
	        || (Number(value) < Number($(params).val())); 
	},'Must be less than given drop off date.');


//Less than Booking area
jQuery.validator.addMethod("lessThan", 
	function(value, element, params) {
    
	    return isNaN(value) && isNaN($(params).val()) 
	        || (Number(value) <= Number($(params).val())); 
	},'Must be less or equal to remaining area.');



jQuery.validator.addMethod("greaterThanPickUp", 
function(value, element, params) {

    if (!/Invalid|NaN/.test(new Date(value))) {
        return new Date(value) > new Date($(params).val());
    }

    return isNaN(value) && isNaN($(params).val()) 
        || (Number(value) > Number($(params).val())); 
},'Must be greater than drop off end date.');


//Custome Validation - Mobile number
jQuery.validator.addMethod('customphone', function (value, element) {
    return this.optional(element) || /^[(]{0,1}[0-9]{3}[)\.\- ]{0,1}[0-9]{3}[\.\- ]{0,1}[0-9]{4}$/.test(value);
}, "Please enter a valid phone number");

//Custome Validation - Price per sq. foot
jQuery.validator.addMethod('customarea', function (value, element) {
    return this.optional(element) || /^\d{0,2}(\.\d{0,2}){0,1}$/.test(value);
}, "Please enter a valid price");

//Custome Validation - Post price drop_off
jQuery.validator.addMethod('customprice', function (value, element) {
    return this.optional(element) || /^\d{0,2}(\.\d{0,2}){0,1}$/.test(value);
}, "Please enter a valid price");

//Custome Validation - Post price pick_up
jQuery.validator.addMethod('custompick', function (value, element) {
    return this.optional(element) || /^\d{0,2}(\.\d{0,2}){0,1}$/.test(value);
}, "Please enter a valid price");


// All Jquery Validation
jQuery(document).ready(function() {



jQuery("#userSignup").validate({

	errorElement:'div',
	rules: {

	  "email":{ remote:"/authenticates/check_email" }
		},
	messages: {
		
	 	"email":{ remote:"Email already exists" }
																
		},
		errorPlacement: function(error, element) {
            jQuery('#email').parent().parent().find('.form-error').html("Email already exists");
        }
	});


jQuery("#user").validate({
	errorElement:'div',
	rules: {
		"user[email]":{
			required:true,
	        email: true
			
		},
		"user[password]":{
			required:true,
			minlength:6
		},
		"user[password_confirmation]":{
			required:true,
			equalTo: "#user_password"
		},
		"user[name]":{
			required:true
		},
		"user[last_name]":{
			required:true
		},
		"user[personal_email]":{
	        email: true
		},
		"user[mobile_number]": 'customphone',

		"termsConditions":{ required:true }
	},
	messages: {

		"user[email]":{
			required: "Please enter email address"
		},
		"user[password]":{
			required: "Please enter password",
			minlength:"do not enter less than 6 characters"
		},
		"user[password_confirmation]":{
			required: "Password confirmation cannot be blank",
			equalTo:"Password does not match"
		},
		"user[name]":{
			required: "Please enter First Name"
		},
		"user[last_name]":{
			required: "Please enter Last Name"
		},
		"user[personal_email]":{
			
		},
		"termsConditions":{ required:"Please accept term and condition" }
	}
});


jQuery("#edit_user").validate({
	errorElement:'div',
	rules: {
		"user[email]":{
			required:true,
	        email: true
			// remote:"/users/check_email"
		},
		"user[name]":{
			required:true
		},
		"user[last_name]":{
			required:true
		},
		"user[password]":{
			required:true,
			minlength:6
		},
		"user[password_confirmation]":{
			required:true,
			minlength:6
		},
		"user[personal_email]":{
	        email: true
		},

		"user[current_password]":{
			required:true
		},
		"user[mobile_number]": 'customphone'
	},
	messages: {

		"user[email]":{
			required: "Please enter email address"
		},
		"user[name]":{
			required: "Please enter First Name"
		},
		"user[last_name]":{
			required: "Please enter Last Name"
		},
		"user[password]":{
			required: "Please enter password",
			minlength:"do not enter less than 6 characters"
		},
		"user[password_confirmation]":{
			required: "Password confirmation cannot be blank",
			minlength:"do not enter less than 6 characters"
		},

		"user[current_password]":{
			required: "Current Password cannot be blank",
		},

		"user[personal_email]":{
			
		}
	}
});

jQuery("#new_post").validate({


	errorElement: "div",
    
    errorPlacement: function(error, element) {
        var trigger = element.next('.ui-datepicker-trigger');
        error.insertAfter(trigger.length > 0 ? trigger : element);
    },

rules: {
  
	"post[area]":{
		required:true,
		number:true,
		min:4,
		max:100
	},
	"post[price_sq_ft]": 'customarea',
	"post[price_sq_ft]":{
		required:true,
		// number:true,
		min:0.50,
		max:100
	},
	"post[price_include_pick_up]": 'custompick',
	"post[price_include_pick_up]":{
		// number:true,
		min:0,
		max:100
	},
	"post[price_include_drop_off]": 'customprice',
	"post[price_include_drop_off]":{
		// number:true,
		min:0,
		max:100
	},
	"post[drop_off_avaibility_start_date]":{
		required:true
	},
	"post[drop_off_avaibility_end_date]":{
		required:true,
		greaterThan: "#post_drop_off_avaibility_start_date"
	},
	"post[pick_up_avaibilty_start_date]":{
		required:true,
		greaterThanPickUp: "#post_drop_off_avaibility_end_date"
	},
	"post[pick_up_avaibility_end_date]":{
		required:true,
		greaterThan: "#post_pick_up_avaibilty_start_date"
	},
	"post[additional_comments]":{
		maxlength:1000
	},
	"post[address]":{
		required:true
	},
	"post[city]":{
		required:true
	},
	"post[state]":{
		required:true
	},
	"post[zip_code]":{
		required:true,
		number:true
	}

},
messages: {

	"post[area]":{
		required: "Please enter Area",
		number:"Please enter integer value"
	},
	"post[price_sq_ft]":{
		required: "Please enter Price per square feet",
		number:"Please enter integer value"
	},
	"post[drop_off_avaibility_start_date]":{
		required: "Please enter Drop off avaibility start date"
	},
	"post[drop_off_avaibility_end_date]":{
		required: "Please enter Drop off avaibility end date"
	},
	"post[pick_up_avaibilty_start_date]":{
		required: "Please enter Pick up avaibilty start date"
	},
	"post[pick_up_avaibility_end_date]":{
		required: "Please enter Pick up avaibility end date"
	},
	"post[price_include_pick_up]":{
		number:"Please enter integer value"
	},
	// "post[price_include_drop_off]":{
	// 	number:"Please enter integer value"
	// },
	"post[address]":{
		required: "Please enter street address"
	},
	"post[city]":{
		required: "Please enter city"
	},
	"post[state]":{
		required: "Please enter state"
	},
	"post[zip_code]":{
		required: "Please enter zip code",
		number: "Please enter integer value"
	}
}
});


jQuery("#new_bank_detail").validate({
errorElement:'div',
rules: {
  
	"bank_detail[full_name]":{
		required:true
	},
	"bank_detail[card_number]":{
		required:true,
		number:true,
		minlength: 8
	}
},
messages: {

	"bank_detail[full_name]":{
		required: "Please enter name"
	},
	"bank_detail[card_number]":{
		required: "Please card number"
	}
}
});

jQuery("#contactus").validate({
errorElement:'div',
rules: {
  
	
	"contactus[subject]":{
	    required:true
	},
	"contactus[message]":{
		required:true
	}
},
messages: {

	
	"contactus[subject]":{
		 required: "Please enter Subject"
	},
	"contactus[message]":{
		required: "Please enter Message"
	}
}
});

jQuery("#new_comment").validate({
	ignore:'', // initialize the plugin
	errorElement:'div',

	rules: {

        "comment[rating]":{
	        required:true
        },
		"comment[comments]":{
			required:true,
			minlength: 4,
			maxlength: 100
		}
	},
	messages: {

		"comment[rating]":{
        required: "Please rate"
        },
		"comment[comments]":{
			required: "Please enter comment"
		}
       
	}
});


jQuery("#booking").validate({

	ignore:'',
	errorElement:'div',

	rules: {
        
        "area":{
	        required:true,
	        number:true ,
	        digits:true,
	        lessThan: "#remaining_area",
	        min: 4
        },
        "booking[dropoff_date]":{
	        required:true
        }
	},
	messages: {

		"area":{
        required: " ",
        min: "greater than or equal to 4"
        }
        ,
        "booking[dropoff_date]":{
	        required:''
        }
       }
	// }, // initialize the plugin
	// errorPlacement: function () {
 //        return false; // <- kill default error labels
 //    }
		

});





 jQuery("#reply_message").validate({

	ignore:'', // initialize the plugin
	errorElement:'div',

	rules: {

        "message[body]":{
	        required:true
	       
        }
	},
	messages: {

		"message[body]":{
        	required: "Please enter message"
        }
       
	}
  });

  jQuery("#browse_post").validate({

	ignore:'', // initialize the plugin
	errorElement:'div',

	rules: {

        "search[price]":{
	        number:true
        },
        "search[area]":{
	        number:true
        },
        "search[miles]":{
	        number:true
        }
	},
	messages: {

		"search[price]":{
        	number:"Please enter integer value"
        },
        "search[area]":{
        	number:"Please enter integer value"
        },
        "search[miles]":{
        	number:"Please enter integer value"
        }

       
	}
  });


 




});