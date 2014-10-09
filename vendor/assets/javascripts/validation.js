jQuery(document).ready(function() {
jQuery("#new_user").validate({
errorElement:'div',
rules: {
  
"user[email]":{
required:true
},
"user[password]":{
required:true
}
},
messages: {

"user[email]":{
required: "Please enter email address",
remote:"email id already exists"
},
"user[password]":{
required: "Please enter password"
}
}
});

jQuery("#user").validate({
errorElement:'div',
rules: {
  
"user[email]":{
required:true,
// remote:"/users/check_email"
},
"user[password]":{
required:true
},
"user[password_confirmation]":{
required:true
},
"user[name]":{
required:true
},
"user[last_name]":{
required:true
},
"user[personal_email]":{
required:true
},
"user[mobile_no]":{
required:true
}
},
messages: {

"user[email]":{
required: "Please enter email address",
// remote:"email id already exists"
},
"user[password]":{
required: "Please enter password"
},
"user[password_confirmation]":{
required: "Please enter Password Confirmation"
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

});