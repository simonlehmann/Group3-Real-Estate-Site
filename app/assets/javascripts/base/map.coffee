map = undefined
geocoder = undefined
infoWindow = undefined
currentLocation = undefined
markers = []
currentRadius = 1000

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
      currentRadius = $('#search_radius').val()
      unless currentRadius
        alert 'No radius set, using default of 1000.'
        currentRadius = 1000
      searchPlace search
      return
    $('#search_school').click ->
      currentRadius = $('#search_radius').val()
      unless currentRadius
        alert 'No radius set, using default of 1000.'
        currentRadius = 1000
      searchSchool()
      return
    $('#search_food').click ->
      currentRadius = $('#search_radius').val()
      unless currentRadius
        alert 'No radius set, using default of 1000.'
        currentRadius = 1000
      searchFood()
      return
    $('#search_petrol').click ->
      currentRadius = $('#search_radius').val()
      unless currentRadius
        alert 'No radius set, using default of 1000.'
        currentRadius = 1000
      searchPetrol()
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
  deleteMarkers()
  infowindow = new (google.maps.InfoWindow)
  service = new (google.maps.places.PlacesService)(map)
  service.nearbySearch {
    location: currentLocation
    radius: currentRadius
    type: [ search_attr ]
  }, callback
  return

searchPetrol = ->
  search = 'gas starions'
  deleteMarkers()
  infowindow = new (google.maps.InfoWindow)
  service = new (google.maps.places.PlacesService)(map)
  service.nearbySearch {
    location: currentLocation
    radius: currentRadius
    type: [ search ]
  }, callbackGreen
  return

searchFood = ->
  search = 'food'
  deleteMarkers()
  infowindow = new (google.maps.InfoWindow)
  service = new (google.maps.places.PlacesService)(map)
  service.nearbySearch {
    location: currentLocation
    radius: currentRadius
    type: [ search ]
  }, callbackOrange
  return

searchSchool = ->
  search = 'school'
  deleteMarkers()
  infowindow = new (google.maps.InfoWindow)
  service = new (google.maps.places.PlacesService)(map)
  service.nearbySearch {
    location: currentLocation
    radius: currentRadius
    type: [ search ]
  }, callbackBlue
  return

callback = (results, status, search) ->
  if status == google.maps.places.PlacesServiceStatus.OK
    i = 0
    while i < results.length
      addMarker results[i].geometry.location
      i++
  return

callbackBlue = (results, status, search) ->
  if status == google.maps.places.PlacesServiceStatus.OK
    i = 0
    while i < results.length
      addBlueMarker results[i].geometry.location
      i++
  return

callbackGreen = (results, status, search) ->
  if status == google.maps.places.PlacesServiceStatus.OK
    i = 0
    while i < results.length
      addMarkerGreen results[i].geometry.location
      i++
  return

callbackOrange = (results, status, search) ->
  if status == google.maps.places.PlacesServiceStatus.OK
    i = 0
    while i < results.length
      addMarkerOrange results[i].geometry.location
      i++
  return

# Adds a marker to the map and push to the array.

addMarkerGreen = (location) ->
  marker = new (google.maps.Marker)(
    position: location
    map: map
    icon: 'http://i63.tinypic.com/mc3r7c.jpg')
  markers.push marker
  return

addMarkerOrange = (location) ->
  marker = new (google.maps.Marker)(
    position: location
    map: map
    icon: 'http://i66.tinypic.com/23w4ppc.png')
  markers.push marker
  return

addBlueMarker = (location) ->
  marker = new (google.maps.Marker)(
    position: location
    map: map
    icon: 'http://i63.tinypic.com/fdv806.png')
  markers.push marker
  return

addMarker = (location) ->
  console.log  'adding marker'
  marker = new (google.maps.Marker)(
    position: location
    map: map
    icon: null)
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
  console.log 'clearing markers'
  setMapOnAll null
  return

# Shows any markers currently in the array.

showMarkers = ->
  setMapOnAll map
  return

# Deletes all markers in the array by removing references to them.

deleteMarkers = ->
  console.log 'deleting markers'
  clearMarkers()
  markers = []
  return


# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)

$(document).ready ready
$(document).on 'page:load', ready
