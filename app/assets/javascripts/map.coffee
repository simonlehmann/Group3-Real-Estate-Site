map = undefined
geocoder = undefined
infoWindow = undefined
currentLocation = undefined
markers = []

# Moved into one ready function to be called across page load and document.ready as discussed on Slack
ready = ->
  # To remove the console error, I'm only running this on the maps page
  loc = window.location.pathname
  console.log loc
  if loc.includes('map')
    #Declare variables/arrays etc
    currentLocation = 
      lat: -34.397
      lng: 150.644
    mapOptions = 
      zoom: 14
      center:
        lat: -34.397
        lng: 150.644
    map = new (google.maps.Map)(document.getElementById('map-canvas'), mapOptions)
    geocoder = new (google.maps.Geocoder)
    
    # Work with submitted address  
    $('#addr_submit').click ->
      address = $('#addr_box').val()
      geocodeAddress geocoder, map, address
      return
    $('#search_attr').click ->
      search = $('#search_box').val()
      searchPlace search
      return
  return

# Convert Address into lat and long and show on map
geocodeAddress = (geocoder, resultsMap, address) ->
  geocoder.geocode { 'address': address }, (results, status) ->
    if status == google.maps.GeocoderStatus.OK
      resultsMap.setCenter results[0].geometry.location
      currentLocation = results[0].geometry.location
      marker = new (google.maps.Marker)(
        map: resultsMap
        position: results[0].geometry.location)
    else
      alert 'Geocode was not successful for the following reason: ' + status
    return
  return

searchPlace = (search_attr) ->
  deleteMarkers
  infowindow = new (google.maps.InfoWindow)
  service = new (google.maps.places.PlacesService)(map)
  service.nearbySearch {
    location: currentLocation
    radius: 500
    type: [ search_attr ]
  }, callback
  return

callback = (results, status) ->
  if status == google.maps.places.PlacesServiceStatus.OK
    i = 0
    while i < results.length
      addMarker results[i].geometry.location
      i++
  return

createMarker = (place) ->
  placeLoc = place.geometry.location
  marker = new (google.maps.Marker)(
    map: map
    position: place.geometry.location)
  google.maps.event.addListener markers, 'click', ->
    infowindow.setContent place.name
    infowindow.open map, this
    return
  return

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)

# Adds a marker to the map and push to the array.

addMarker = (location) ->
  alert 'add'
  marker = new (google.maps.Marker)(
    position: location
    map: map)
  markers.push marker
  return

# Sets the map on all markers in the array.

setMapOnAll = (map) ->
  i = 0
  while i < markers.length
    markers[i].setMap map
    i++
  return

# Removes the markers from the map, but keeps them in the array.

clearMarkers = ->
  alert 'clear'
  setMapOnAll null
  return

# Shows any markers currently in the array.

showMarkers = ->
  setMapOnAll map
  return

# Deletes all markers in the array by removing references to them.

deleteMarkers = ->
  alert 'delete markers'
  clearMarkers()
  markers = []
  return

$(document).ready ready
$(document).on 'page:load', ready