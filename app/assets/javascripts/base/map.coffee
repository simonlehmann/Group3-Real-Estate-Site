# Declare current location variable for use
distance = 5000
places = undefined
currentLocation = undefined
map = undefined
markers = []
service = undefined
colour = undefined

# On page ready, continue with this code
ready = ->
  $('.map-buttons #places-dropdown').dropdown
    onChange: (value, text, $choice) ->
      deleteMarkers()
      colour = value
      searchPlace(text)
      console.log value
      return
  # Check if a map canvas exists
  if $('#map-canvas').length
    # Get the properties address
    location_addr = $('#map-canvas').data('addr')
    # Initiate a new instance of geocoder
    geocoder = new (google.maps.Geocoder)
    # Conver the address into lat and lng values and store in currentLocation
    geocodeAddress(location_addr, geocoder)
# Function to get coords from human readable address
geocodeAddress = (address, geocoder) ->
  geocoder.geocode { 'address': address}, (results, status) ->
    # Check if geocoder is available and working
    if status == google.maps.GeocoderStatus.OK
      # Set currentLocation to lat and lng of address
      currentLocation = results[0].geometry.location
      # Call initializeMap function to build and display the map
      initializeMap()
    else
      # If geocoder fails, notify
      console.log 'Geocode was not successful for the following reason: ' + status
    return
  return
# Build and display initial map
initializeMap = ->
  # Set map options
  mapOptions = 
    zoom: 14
    center:
      lat: currentLocation.lat()
      lng: currentLocation.lng()
  # Initiate map
  map = new (google.maps.Map)(document.getElementById('map-canvas'), mapOptions)
  # Set property marker
  marker = new (google.maps.Marker)(
      map: map
      position: currentLocation)
  # Initiate service object
  service = new (google.maps.places.PlacesService)(map)
# Function to find places based on search criteria
searchPlace = (search_attr) ->
  service.nearbySearch {
    location: currentLocation
    radius: distance
    name: [ search_attr ]
  }, callback
  return

deleteMarkers = ->
  markers = []
  clearMarkers()
  return

callback = (results, status, search) ->
  if status == google.maps.places.PlacesServiceStatus.OK
    switch (colour)
      when '1'
        i = 0
        while i < results.length
          addBlueMarker results[i].geometry.location
          i++
      when '2'
        i = 0
        while i < results.length
          addBlueMarker results[i].geometry.location
          i++
      when '3'
        i = 0
        while i < results.length
          addBlueMarker results[i].geometry.location
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
  console.log 'add marker'
  marker = new (google.maps.Marker)(
    position: location
    map: map
    icon: 'http://i63.tinypic.com/fdv806.png')
  markers.push marker
  return

clearMarkers = ->
  setMapOnAll null
  return

# Shows any markers currently in the array.
showMarkers = ->
  setMapOnAll map
  return
# Sets the map on all markers in the array.
setMapOnAll = (map) ->
  i = 0
  if !markers == undefined
    while i < markers.length
      markers[i].setMap map
      i++
    return
  return

$(document).ready ready