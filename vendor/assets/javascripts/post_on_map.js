 function postOnMap(latitude, longitude, rendar_to)
 {
   function initialize() {

        // Create an array of styles.
        var styles = [
          {
            stylers: [
              { hue: "#00b4ff" },
              { saturation: 50 }
            ]
          },{
            featureType: "road",
            elementType: "geometry",
            stylers: [
              { hue: "#28A0E5" },
              { visibility: "simplified" }
            ]
          },{
            featureType: "road",
            elementType: "labels",
            stylers: [
              { visibility: "off" }
            ]
          }
        ];

        // Create a new StyledMapType object, passing it the array of styles,
        // as well as the name to be displayed on the map type control.
        var styledMap = new google.maps.StyledMapType(styles, {name: "Styled Map"});

        var myLatlng = new google.maps.LatLng(latitude, longitude);
        var mapOptions = {
          zoom: 12,
          center: myLatlng,
          panControl: true,
          zoomControl: true,
          disableDefaultUI: true
        }
        var map = new google.maps.Map(document.getElementById(rendar_to), mapOptions);
        var marker = new google.maps.Marker({
              position: myLatlng,
              map: map,
              icon: "/assets/marker.png"
          });
          //Associate the styled map with the MapTypeId and set it to display.
          map.mapTypes.set('map_style', styledMap);
          map.setMapTypeId('map_style');
      }
      google.maps.event.addDomListener(window, 'load', initialize);

  }