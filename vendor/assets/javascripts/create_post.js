$(document).ready(function() {
// Tooltip only Text
$('.masterTooltip').hover(function(){
        // Hover over code
        var title = $(this).attr('title');
        $(this).data('tipText', title).removeAttr('title');
        $('<p class="tooltip"></p>')
        .text(title)
        .appendTo('body')
        .fadeIn('slow');
}, function() {
        // Hover out code
        $(this).attr('title', $(this).data('tipText'));
        $('.tooltip').remove();
}).mousemove(function(e) {
        var mousex = e.pageX + 15; //Get X coordinates
        var mousey = e.pageY + -18; //Get Y coordinates
        $('.tooltip')
        .css({ top: mousey, left: mousex })
});
});

$(function() {
  $('#post_photo').on('change', function(event) {
    var files = event.target.files;
    var image = files[0]
    var reader = new FileReader();
    reader.onload = function(file) {
      var img = new Image();
      img.src = file.target.result;
      img.width = 91;
      img.height = 61;
      $('#target').html(img);
    }
    reader.readAsDataURL(image);
    console.log(files);
  });
});

  $(window).load(function(){
    var a = document.getElementById('post_drop_off').checked
    var b = document.getElementById('post_pick_up').checked
    if (a == true){
      $('#post_price_include_drop_off').removeAttr('disabled');
    }
    if (b == true){
      $('#post_price_include_pick_up').removeAttr('disabled');
    }

    $("#post_drop_off").click(function() {
        $("#post_price_include_drop_off").attr("disabled", !this.checked); 
    });

    $("#post_pick_up").click(function() {
        $("#post_price_include_pick_up").attr("disabled", !this.checked); 
    });
  });//]]>  