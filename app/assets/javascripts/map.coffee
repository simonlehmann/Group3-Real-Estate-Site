map = undefined
geocoder = undefined

$(document).ready ->
  #Declare variables/arrays etc
  mapOptions = 
    zoom: 14
    center:
      lat: -34.397
      lng: 150.644
  map = new (google.maps.Map)(document.getElementById('map-canvas'), mapOptions)
  geocoder = new (google.maps.Geocoder)
  return

$(document).ready ->
  $('#addr_submit').click ->
    address = $('#addr_box').val()
    geocodeAddress geocoder, map, address
    return

geocodeAddress = (geocoder, resultsMap, address) ->
  geocoder.geocode { 'address': address }, (results, status) ->
    if status == google.maps.GeocoderStatus.OK
      resultsMap.setCenter results[0].geometry.location
      marker = new (google.maps.Marker)(
        map: resultsMap
        position: results[0].geometry.location)
    else
      alert 'Geocode was not successful for the following reason: ' + status
    return
  return
