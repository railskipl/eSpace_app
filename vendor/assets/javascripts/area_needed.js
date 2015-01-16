  jQuery(document).ready(function(){

  $('#area').live('input',function() {
        update_amounts();
    });
    function update_amounts()
    {
        // update the total to sum
        var qty = parseInt($('#area').val());
        var price = parseFloat($('#price').val());
        var drop_off = 0;
        var pickup = 0;
        if($('#checkbox1').is(":checked"))
        {
          var drop_off = parseFloat($('#dropoff').val());
        }
        if($('#checkbox2').is(":checked"))
        {
          var pickup = parseFloat($('#pickup').val());
        }
          $('#area_needed').html("$"+(qty * price ? qty * price : 0)+"");
          $('#check_drop').html("$"+(drop_off)+"");
          $('#check_pickup').html("$"+(pickup)+"");
          $('#dropoff_price').val(drop_off);
          $('#pickup_price').val(pickup);
          $('#total').html("$"+(qty * price + drop_off + pickup ? qty * price + drop_off + pickup : 0).toFixed(2)+"");
          $('#booking_price').val((qty * price + drop_off + pickup ? qty * price + drop_off + pickup : 0).toFixed(2));
          $('#totalPrice').val(((qty * price + drop_off + pickup) * 100 ? (qty * price + drop_off + pickup) * 100 : 0));
    }


    //Pickup and drop off calculation.
    $('#checkbox1').change(function() {
       var qty = parseInt($('#area').val());
       var price = parseFloat($('#price').val());
       var drop_off = 0;
       var pickup = 0;
        if($('#checkbox1').is(":checked"))
        {
          var drop_off = parseFloat($('#dropoff').val());
        }
        if($('#checkbox2').is(":checked"))
        {
          var pickup = parseFloat($('#pickup').val());
        }
        var total = parseFloat((qty * price ? qty * price : 0).toFixed(2));
        if($(this).is(":checked")) {
          $('#area_needed').html("$"+(qty * price ? qty * price : 0)+"");
          $('#check_drop').html("$"+(drop_off)+"");
          $('#check_pickup').html("$"+(pickup)+"");
          $('#dropoff_price').val(drop_off);
          $('#pickup_price').val(pickup);
          $('#total').html("$"+(qty * price + drop_off + pickup ? qty * price + drop_off + pickup : 0).toFixed(2)+"");
          $('#booking_price').val((total + drop_off + pickup ? total + drop_off + pickup : 0).toFixed(2));
          $('#totalPrice').val(((qty * price + drop_off + pickup) * 100 ? (qty * price + drop_off + pickup) * 100 : 0));
           var fees = (total + drop_off + pickup ? total + drop_off + pickup : 0).toFixed(2);
            if (fees <= 8)
            {
               var cut_off = fees * 0.80;
               $('#cut_off').html("+ Our Commission&nbsp;" + cut_off.toFixed(2));
            }
             else if (price > 8)
             {
                var cut_off =  fees * (10/100);
                $('#cut_off').html("+ Our Cut&nbsp;" + cut_off.toFixed(2));
             }
          }
        else
        {
          $('#area_needed').html("$"+(qty * price ? qty * price : 0)+"");
          $('#check_drop').html("$"+(drop_off)+"");
          $('#check_pickup').html("$"+(pickup)+"");
          $('#dropoff_price').val(drop_off);
          $('#pickup_price').val(pickup);
          $('#total').html("$"+(qty * price + drop_off + pickup ? qty * price + drop_off + pickup : 0).toFixed(2)+"");
          $('#booking_price').val((total + drop_off + pickup ? total + drop_off + pickup : 0).toFixed(2));
          $('#totalPrice').val(((qty * price + drop_off + pickup) * 100 ? (qty * price + drop_off + pickup) * 100 : 0));
        }
    });



    $('#checkbox2').change(function() {
       var qty = parseInt($('#area').val());
       var price = parseFloat($('#price').val());
       var drop_off = 0;
       var pickup = 0;
       if($('#checkbox1').is(":checked"))
        {
          var drop_off = parseFloat($('#dropoff').val());
        }
        if($('#checkbox2').is(":checked"))
        {
          var pickup = parseFloat($('#pickup').val());
        }
        var total = parseFloat((qty * price ? qty * price : 0).toFixed(2));
        if($(this).is(":checked")) {
          $('#area_needed').html("$"+(qty * price ? qty * price : 0)+"");
          $('#check_drop').html("$"+(drop_off)+"");
          $('#check_pickup').html("$"+(pickup)+"");
          $('#dropoff_price').val(drop_off);
          $('#pickup_price').val(pickup);
          $('#total').html("$"+(qty * price + drop_off + pickup ? qty * price + drop_off + pickup : 0).toFixed(2)+"");
          $('#booking_price').val((total + drop_off + pickup ? total + drop_off + pickup : 0).toFixed(2));
          $('#totalPrice').val(((qty * price + drop_off + pickup) * 100 ? (qty * price + drop_off + pickup) * 100 : 0));
        }
        else
        {
           $('#area_needed').html("$"+(qty * price ? qty * price : 0)+"");
           $('#check_drop').html("$"+(drop_off)+"");
           $('#check_pickup').html("$"+(pickup)+"");
           $('#dropoff_price').val(drop_off);
           $('#pickup_price').val(pickup);
          $('#total').html("$"+(qty * price + drop_off + pickup ? qty * price + drop_off + pickup : 0).toFixed(2)+"");
          $('#booking_price').val((total + drop_off + pickup ? total + drop_off + pickup : 0).toFixed(2));
          $('#totalPrice').val(((qty * price + drop_off + pickup) * 100 ? (qty * price + drop_off + pickup) * 100 : 0));
        }
    });
  
  });//]]>