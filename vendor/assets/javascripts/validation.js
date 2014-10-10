jQuery(document).ready(function() {

jQuery("#userSignup").validate({
	errorElement:'div',
	rules: {

	  "email":{ remote:"/authenticates/check_email" }
		},
	messages: {
		
	 	"email":{ remote:"Email already exists" }
																
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
			minlength:6
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
		"user[mobile_number]":{
			number:true
		},
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
			required: "Password Confirmation cannot be blank",
			minlength:"do not enter less than 6 characters"
		},
		"user[name]":{
			required: "Please enter First Name"
		},
		"user[last_name]":{
			required: "Please enter Last Name"
		},
		"user[personal_email]":{
			
		},
		"user[mobile_number]":{
			number: "Please enter valid mobile number"
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
		"user[personal_email]":{
	        email: true
		},
		"user[mobile_number]":{
			number:true
		}
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
		"user[personal_email]":{
			
		},
		"user[mobile_number]":{
			number: "Please enter valid mobile number"
		}
	}
});

jQuery("#new_post").validate({
errorElement:'div',
rules: {
  
	"post[area]":{
		required:true,
		number:true
	},
	"post[price_sq_ft]":{
		required:true
	},
	"post[price_include_pick_up]":{
		number:true
	},
	"post[price_include_drop_off]":{
		number:true
	},
	"post[pick_up_avaibilty_start_date]":{
		required:true
	},
	"post[pick_up_avaibility_end_date]":{
		required:true
	},
	"post[drop_off_avaibility_start_date]":{
		required:true
	},
	"post[drop_off_avaibility_end_date]":{
		required:true
	},
	"post[address]":{
		required:true
	}
},
messages: {

	"post[area]":{
		required: "Please enter Area",
		number:"Please enter integer value"
	},
	"post[price_sq_ft]":{
		required: "Please enter Price sq ft"
	},
	"post[price_include_pick_up]":{
		number:"Please enter integer value"
	},
	"post[price_include_drop_off]":{
		number:"Please enter integer value"
	},
	"post[pick_up_avaibilty_start_date]":{
		required: "Please enter Pick up avaibilty start date"
	},
	"post[pick_up_avaibility_end_date]":{
		required: "Please enter Pick up avaibility end date"
	},
	"post[drop_off_avaibility_start_date]":{
		required: "Please enter Drop off avaibility start date"
	},
	"post[address]":{
		required: "Please enter Address"
	},
	"post[drop_off_avaibility_end_date]":{
		required: "Please enter Drop off avaibility end date"
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
  
"contactus[name]":{
required:true
},
"contactus[email]":{
required:true
},
"contactus[subject]":{
required:true
},
"contactus[message]":{
required:true
}
},
messages: {

"contactus[name]":{
required: "Please enter Name"
},
"contactus[email]":{
required: "Please enter Email"
},
"contactus[subject]":{
required: "Please enter Subject"
},
"contactus[message]":{
required: "Please enter Message"
}
}
});
});