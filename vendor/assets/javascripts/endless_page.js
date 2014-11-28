
  jQuery(function() {
    if ($('.pagination').length) {
      $(".description").scroll(function() {
        var url;
        url = $('.pagination .next_page').attr('href');
        if (url && $(".description").scrollTop() > $(".description").prop("scrollHeight") - $(".description").height() - 50) {
          $('.pagination').html('<img src="/assets/loading.gif" alt="Loading..." title="Loading..." />');
          return $.getScript(url);
        }
      });
      return $(".description").scroll();
    }
  });
