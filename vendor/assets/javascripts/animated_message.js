            //Animated message
              var showToaster = function(animated, text) {
                var replaceText = function (text) {
                  var graf = animated.find('p');
                  
                  graf.text(text);
                };

                if (text != undefined) {
                  replaceText(text);
                }

                animated.addClass('fadeInUp');
                animated.addClass('toaster_opacity');
                setTimeout(closeToaster, 8250);
              };

              var closeToaster = function() {
                $('.animated').removeClass('fadeInUp');
                $(".animated").removeClass("toaster_opacity");
                $("#flashMsg").remove();
              };

              var setToaster = function(animated, text) {
                if ($('.animated.fadeInUp').length) {
                  if (Modernizr && Modernizr.csstransitions) {
                    $('.animated').one(
                      'transitionend oTransitionEnd webkitTransitionEnd',
                      function() { showToaster(animated, text) }
                    );
                    closeToaster();
                  } else {
                    showToaster(animated, text);
                  }
                } else {
                  showToaster(animated, text);
                }
              };

              $('body').delegate('.animated .close_x_bright', 'click', closeToaster);

              $(function () {
                $('.animated').bind('pop', function (e, text) {
                  setToaster($(e.target), text);
                });

                if ($('.animated p').text().length > 0) {
                  setToaster($('.animated'));
                }
                
              });
