 Stripe.setPublishableKey('pk_test_17xmTuMVQ5oVgcT0AWY6XcNo');
   $(document).ready(function() {

    function addInputNames() {
    // Not ideal, but jQuery's validate plugin requires fields to have names
    // so we add them at the last possible minute, in case any javascript
    // exceptions have caused other parts of the script to fail.
      $(".card_number").attr("name", "card_number")
      $(".card_code").attr("name", "card_code")
      $(".card_year").attr("name", "card_year")
    }
 
    function removeInputNames() {
      $(".card_number").removeAttr("name")
      $(".card_code").removeAttr("name")
      $(".card_year").removeAttr("name")
      }
 
      function submit(form) {
      // remove the input field names for security
      // we do this *before* anything else which might throw an exception
      removeInputNames(); // THIS IS IMPORTANT!
     
      // given a valid form, submit the payment details to stripe
      // https://stripe.com/docs/testing
      $(form['submit-button']).attr("disabled", "disabled")
     
        Stripe.createToken({
        number: $('.card_number').val(),
        cvc: $('.card_code').val(),
        exp_month: $('.card-expiry-month').val(),
        exp_year: $('.card-expiry-year').val()
        }, function(status, response) {
        if (response.error) {
        // re-enable the submit button
        $(form['submit-button']).removeAttr("disabled")
        // show the error
        $(".payment-errors").html(response.error.message);
        // we add these names back in so we can revalidate properly
        addInputNames();
        } else {
        // token contains id, last4, and card type
        var token = response['id'];
     
        // insert the stripe token
        var input = $("<input name='stripe_card_token' value='" + token + "' style='display:none;' />");
        form.appendChild(input[0])
     
          // and submit
      form.submit();
        }
      });
       return false;
      }
      // add custom rules for credit card validating
      jQuery.validator.addMethod("cardNumber", Stripe.validateCardNumber, "Please re-enter number");
      jQuery.validator.addMethod("cardCVC", Stripe.validateCVC, "Please re-enter CVV");
      jQuery.validator.addMethod("cardExpiry", function() {
      return Stripe.validateExpiry($(".card-expiry-month").val(),
      $(".card-expiry-year").val())
      }, "Please enter a valid expiration");
 
      // We use the jQuery validate plugin to validate required params on submit
      $("#new_bank_detail").validate({
        submitHandler: submit,
        rules: {
        "card_code" : {
          cardCVC: true,
          required: true
        },
      "bank_detail[full_name]":{
         required:true
        },
        "card_number" : {
          cardNumber: true,
          required: true
        },
        "card-expiry-year" : "cardExpiry" // we don't validate month separately
        }

        });
 
        // adding the input field names is the last step, in case an earlier step errors
       addInputNames();
  });