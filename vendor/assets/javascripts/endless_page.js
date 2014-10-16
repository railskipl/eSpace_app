
  jQuery(function() {
    if ($('.pagination').length) {
      $(window).scroll(function() {
        var url;
        url = $('.pagination .next_page').attr('href');
        if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
          $('.pagination').text("Fetching .....");
          return $.getScript(url);
        }
      });
      return $(window).scroll();
    }
  });
