jQuery(document).ready(function() {


jQuery("#user").validate({
errorElement:'div',
rules: {
	"user[email]":{
		required:true,
        email: true
		// remote:"/users/check_email"
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
		required:true,
        email: true
	},
	"user[mobile_no]":{
		required:true
	}
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
		required: "Please enter Name"
	},
	"user[last_name]":{
		required: "Please enter Last Name"
	},
	"user[personal_email]":{
		required: "Please enter Personal Email"
	},
	"user[mobile_no]":{
		required: "Please enter Mobile no"
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


});