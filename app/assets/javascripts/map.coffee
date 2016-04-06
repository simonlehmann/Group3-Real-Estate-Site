$(document).ready ->
  #Declare variables/arrays etc
  mapOptions = 
    zoom: 5
    center: new (google.maps.LatLng)(37.09024, -100.712891)
  map = new (google.maps.Map)(document.getElementById('map-canvas'), mapOptions)
  return