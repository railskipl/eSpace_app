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
required:true
},
"user[password]":{
required:true
},
"user[password_confirmation]":{
required:true
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
required: "Please enter Password Confirmation"
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

});