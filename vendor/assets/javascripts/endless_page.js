
  jQuery(function() {
    if ($('.pagination').length) {
      $(".description").scroll(function() {
        var url;
        url = $('.pagination .next_page').attr('href');
        if (url && $(".description").scrollTop() > $(".description").prop("scrollHeight") - $(".description").height() - 50) {
          $('.pagination').text("Fetching .....");
          return $.getScript(url);
        }
      });
      return $(".description").scroll();
    }
  });
