jQuery.validator.addMethod("date", function(date, element) {
                return this.optional(element) || date.match(/^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$/);
            }, "Please select a valid date");


jQuery(document).ready(function() {

jQuery("#admin_create_user").validate({
	errorElement:'div',
	rules: {
  
	"user[name]":{
		required:true
	},
	"user[last_name]":{
		required:true
	},
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
	}
},
messages: {

	"user[name]":{
		required: "Please enter Name"
	},
	"user[last_name]":{
		required: "Please enter Last Name"
	},
	"user[email]":{
		required: "Please enter Email"
	},
	"user[password]":{
		required: "Please enter Password"
	},
	"user[password_confirmation]":{
		required: "Please enter Password Confirmation",
		equalTo: "Password does not match"
	}
}
});

jQuery("#new_page").validate({
errorElement:'div',
rules: {
  
"page[title]":{
	required:true
},
"page[body]":{
	required:true
},
"page[meta_title]":{
required:true
},
"page[meta_description]":{
required:true
}
},
messages: {

"page[title]":{
	required: "Please enter Title"
},
"page[body]":{
	required: "Please enter Body"
},
"page[meta_title]":{
required: "Please enter Meta title"
},
"page[meta_description]":{
required: "Please enter Meta Description"
}
}
});

jQuery("#new_faq").validate({
errorElement:'div',
rules: {
  
"faq[title]":{
	required:true
},
"faq[question]":{
	required:true
},
"faq[answer]":{
required:true
},

},
messages: {

"faq[title]":{
	required: "Please enter Title"
},
"faq[question]":{
	required: "Please enter Question"
},
"faq[answer]":{
required: "Please enter Answer"
}
}
});

jQuery("#new_about_u").validate({
errorElement:'div',
rules: {
  
"about_u[name]":{
	required:true
},
"about_u[photo]":{
	required:true
},
"about_u[content]":{
required:true
},

},
messages: {

"about_u[name]":{
	required: "Please enter name"
},
"about_u[photo]":{
	required: ""
},
"about_u[content]":{
required: "Please enter Content"
}
}
});

	jQuery("#new_access_id").validate({
		errorElement:'div',
		rules: {
		  
			"access_id[email]":{
			required:true
			}

		},
		messages: {

			"access_id[email]":{
			required: "Please enter valid domain."
			}
		}
	});

	jQuery("#admin_posts").validate({
		errorElement:'div',
    
	    errorPlacement: function(error, element) {
	        var trigger = element.next('.ui-datepicker-trigger');
	        error.insertAfter(trigger.length > 0 ? trigger : element);
	    },
	    
		rules: {
		  
		"start_date":{
			required:true,
			date: "#start_date"
		},
		"end_date":{
			required:true,
			date: "#end_date"
		}

		},
		messages: {

		"start_date":{
			required: "Please enter date."
		},
		"end_date":{
			required: "Please enter date."
		}
		}
	});




	jQuery("#admin_users").validate({
		errorElement:'div',
    
	    errorPlacement: function(error, element) {
	        var trigger = element.next('.ui-datepicker-trigger');
	        error.insertAfter(trigger.length > 0 ? trigger : element);
	    },
	    
		rules: {
		  
		"start_date":{
			required:true,
			date: "#start_date"
		},
		"end_date":{
			required:true,
			date: "#end_date"
		},
		"q":{
			required:true
		}
	},
		messages: {

		"start_date":{
			required: "Please enter date."
		},
		"end_date":{
			required: "Please enter date."
		},
		"q":{
			required: "Please enter Name"
		}
		}
	});


	jQuery("#dispute").validate({
		errorElement:'div',
		rules: {
		  
		"amount":{
			required:true,
			number:true
		}

		},
		messages: {

		"amount":{
			required: "Please enter amount."
			}
		}
	});




});