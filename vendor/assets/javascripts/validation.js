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
required: "Please enter Address",
number:"Please enter integer value"
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
max: 8
}
},
messages: {

"bank_detail[full_name]":{
required: "Please enter Area"
},
"bank_detail[card_number]":{
required: "Please Card Number"
}
}
});

});