var map;
var infoWindow;
var markersData = [
 sforce.apex.execute("GoogleMaps", "SerializeDados"
 	});
 ];

function initialize() {
   var mapOptions = {
      center: new google.maps.LatLng(),
      zoom: 9,
      mapTypeId: 'roadmap',
   };

   map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
   infoWindow = new google.maps.InfoWindow();
   google.maps.event.addListener(map, 'click', function() {
      infoWindow.close();
   });
   displayMarkers();
}
google.maps.event.addDomListener(window, 'load', initialize);


function displayMarkers(){
   var bounds = new google.maps.LatLngBounds();
   for (var i = 0; i < markersData.length; i++){

      var latlng = new google.maps.LatLng(markersData[i].LocalizacaoGeograficaDoCheckInGeo__Latitude__s, markersData[i].LocalizacaoGeograficaDoCheckInGeo__Longitude__s);
      var nome = markersData[i].Conta__c;
      var data = markersData[i].DataHoraDoCheckOut__c;


      createMarker(latlng, nome, data);
      bounds.extend(latlng);  
   }
   map.fitBounds(bounds);
}

function createMarker(latlng, nome, data){
   var marker = new google.maps.Marker({
      map: map,
      position: latlng,
      title: nome
   });
   google.maps.event.addListener(marker, 'click', function() {
      var iwContent = '<div id="iw_container">' +
            '<div class="iw_title">' + nome + '</div>' +
         '<div class="iw_content">' + data + '</div></div>';
      infoWindow.setContent(iwContent);
      infoWindow.open(map, marker);
   });
}
