# Declare current location variable for use
currentLocation = undefined

# On page ready, continue with this code
ready = ->
  # Get the properties address
  location_addr = $('#map-canvas').data('addr')
  # Initiate a new instance of geocoder
  geocoder = new (google.maps.Geocoder)
  # Conver the address into lat and lng values and store in currentLocation
  geocodeAddress(location_addr, geocoder)

geocodeAddress = (address, geocoder) ->
  geocoder.geocode { 'address': address}, (results, status) ->
    if status == google.maps.GeocoderStatus.OK
      currentLocation = results[0].geometry.location
      initializeMap()
    else
      alert 'Geocode was not successful for the following reason: ' + status
    return
  return

initializeMap = ->
  mapOptions = 
    zoom: 14
    center:
      lat: currentLocation.lat()
      lng: currentLocation.lng()
  map = new (google.maps.Map)(document.getElementById('map-canvas'), mapOptions)
  marker = new (google.maps.Marker)(
      map: map
      position: currentLocation)

$(document).ready ready