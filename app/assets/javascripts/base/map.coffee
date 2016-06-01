# Created: Michael White
# Date: 16/05/2016
# 
# The following coffeescript is for the map to be used in the property page
# 
# Declare current location variable for use
distance = 5000
places = undefined
currentLocation = undefined
map = undefined
markers = []
service = undefined
colour = undefined
infoWindow = undefined

# On page ready, continue with this code
ready = ->
  # Hide map unavailable
  $('#map-unavailable').hide()
  # Initiate places dropdown
  $('.map-buttons #places-dropdown').dropdown
    # When a selection is changed, do the following
    onChange: (value, text, $choice) ->
      # Delete and clear current markers
      deleteMarkers()
      colour = value
      places = $choice.data 'type' # Needed to grab the data-type not the $choice.context.attributes[0].value
      searchPlace(places)
      return
  # Initiate distance dropdown
  $('.map-buttons #distance-dropdown').dropdown
    # When a selection is changed, do the following
    onChange: (value, text, $choice) ->
      distance = value
      deleteMarkers()
      if places != undefined
        searchPlace(places)
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
      # Hide dropdowns 
      $('#places-dropdown').hide()
      $('#distance-dropdown').hide()
      # Show map unavailable div
      $('#map-unavailable').show()
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
  # Initiate infoWindow object
  infoWindow = new (google.maps.InfoWindow) 
# Function to process places result and call add marker functions
processResults = (results, status, pagination) ->
  # Check if Places Service is OK
  if status != google.maps.places.PlacesServiceStatus.OK
    return
  else
    # Check current option and add marker appropriate to option
    switch (colour)
      when '1'
        i = 0
        # Do for each marker - School
        while i < results.length
          # Check if the distance of the place is within the amount specified from the property
          if getDistance(currentLocation, results[i].geometry.location) <= distance
            addSchoolMarker(results[i])
          i++
      when '2'
        i = 0
        # Do for each marker - Shopping Mall
        while i < results.length
          # Check if the distance of the place is within the amount specified from the property
          if getDistance(currentLocation, results[i].geometry.location) <= distance
            addShoppingMarker results[i]
          i++
      when '3'
        i = 0
        # Do for each marker - Airport
        while i < results.length
          # Check if the distance of the place is within the amount specified from the property
          if getDistance(currentLocation, results[i].geometry.location) <= distance
            addAirportMarker results[i]
          i++
      when '4'
        i = 0
        # Do for each marker - Hospital
        while i < results.length
          # Check if the distance of the place is within the amount specified from the property
          if getDistance(currentLocation, results[i].geometry.location) <= distance
            addHospitalMarker results[i]
          i++
      when '5'
        i = 0
        # Do for each marker - Food
        while i < results.length
          # Check if the distance of the place is within the amount specified from the property
          if getDistance(currentLocation, results[i].geometry.location) <= distance
            addFoodMarker results[i]
          i++
      when '6'
        i = 0
        # Do for each marker - Petrol Station
        while i < results.length
          # Check if the distance of the place is within the amount specified from the property
          if getDistance(currentLocation, results[i].geometry.location) <= distance
            addPetrolMarker results[i]
          i++
      else
        i = 0
        # Do for each marker - Default
        while i < results.length
          # Check if the distance of the place is within the amount specified from the property
          if getDistance(currentLocation, results[i].geometry.location) <= distance
            addDefaultMarker results[i]
          i++
    # If there is more than 20 results, next page.
    if pagination.hasNextPage
      pagination.nextPage()
  return
# Function to find places based on search criteria
searchPlace = (search_attr) ->
  service.nearbySearch {
    location: currentLocation
    # Show first 60 based on distance from property
    rankBy: google.maps.places.RankBy.DISTANCE
    name: [ search_attr ]
  }, processResults
  return
# Function to delete markers
deleteMarkers = ->
  # Clear markers from the map
  clearMarkers()
  # Clear markers array
  markers = []
  return
# Adds a Airport marker to the map and push to the array
addAirportMarker = (place) ->
  marker = new (google.maps.Marker)(
    position: place.geometry.location
    map: map
    icon: 'https://dl.dropboxusercontent.com/u/902818/markers/airport_marker.png?raw=1')
  # Add listener for marker click
  google.maps.event.addListener marker, 'click', ->
    # Set content string for marker infoWindow
    contentString = "<p>"+place.name+"</p>"
    # set infoWindow content and open the map on the marker
    infoWindow.setContent contentString
    infoWindow.open map, marker
    return
  markers.push marker
  return
# Adds a Default marker to the map and push to the array
addDefaultMarker = (place) ->
  marker = new (google.maps.Marker)(
    position: place.geometry.location
    map: map)
  # Add listener for marker click
  google.maps.event.addListener marker, 'click', ->
    # Set content string for marker infoWindow
    contentString = place.name
    # set infoWindow content and open the map on the marker
    infoWindow.setContent contentString
    infoWindow.open map, marker
    return
  markers.push marker
  return
# Adds a Shopping marker to the map and push to the array
addShoppingMarker = (place) ->
  marker = new (google.maps.Marker)(
    position: place.geometry.location
    map: map
    icon: 'https://dl.dropboxusercontent.com/u/902818/markers/shopping_marker.png?raw=1')
  # Add listener for marker click
  google.maps.event.addListener marker, 'click', ->
    # Set content string for marker infoWindow
    contentString = place.name
    # set infoWindow content and open the map on the marker
    infoWindow.setContent contentString
    infoWindow.open map, marker
    return
  markers.push marker
  return
# Adds a School marker to the map and push to the array
addSchoolMarker = (place) ->
  marker = new (google.maps.Marker)(
    position: place.geometry.location
    map: map
    icon: 'https://dl.dropboxusercontent.com/u/902818/markers/school_marker.png?raw=1')
  # Add listener for marker click
  google.maps.event.addListener marker, 'click', ->
    # Set content string for marker infoWindow
    contentString = "<p>"+place.name+"</p>"
    # set infoWindow content and open the map on the marker
    infoWindow.setContent contentString
    infoWindow.open map, marker
    return
  markers.push marker
  return
# Adds a Hospital marker to the map and push to the array
addHospitalMarker = (place) ->
  marker = new (google.maps.Marker)(
    position: place.geometry.location
    map: map
    icon: 'https://dl.dropboxusercontent.com/u/902818/markers/hospital_marker.png?raw=1')
  # Add listener for marker click
  google.maps.event.addListener marker, 'click', ->
    # Set content string for marker infoWindow
    contentString = place.name
    # set infoWindow content and open the map on the marker
    infoWindow.setContent contentString
    infoWindow.open map, marker
    return
  markers.push marker
  return
# Adds a Food marker to the map and push to the array
addFoodMarker = (place) ->
  marker = new (google.maps.Marker)(
    position: place.geometry.location
    map: map
    icon: 'https://dl.dropboxusercontent.com/u/902818/markers/food_marker.png?raw=1')
  # Add listener for marker click
  google.maps.event.addListener marker, 'click', ->
    # Set content string for marker infoWindow
    contentString = place.name
    # set infoWindow content and open the map on the marker
    infoWindow.setContent contentString
    infoWindow.open map, marker
    return
  markers.push marker
  return
# Adds a Petrol marker to the map and push to the array
addPetrolMarker = (place) ->
  marker = new (google.maps.Marker)(
    position: place.geometry.location
    map: map
    icon: 'https://dl.dropboxusercontent.com/u/902818/markers/petrol_marker.png?raw=1')
  # Add listener for marker click
  google.maps.event.addListener marker, 'click', ->
    # Set content string for marker infoWindow
    contentString = place.name
    # set infoWindow content and open the map on the marker
    infoWindow.setContent contentString
    infoWindow.open map, marker
    return
  markers.push marker
  return
# Clear markers from the map
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
  while i < markers.length
    markers[i].setMap map
    i++
  return
# Do some math to do some stuff
rad = (x) ->
  x * Math.PI / 180
# Check if the distance between the two locations is within the specified value
getDistance = (p1, p2) ->
  # Earth’s mean radius in meter
  R = 6378137
  dLat = rad(p2.lat() - p1.lat())
  dLong = rad(p2.lng() - p1.lng())
  a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(rad(p1.lat())) * Math.cos(rad(p2.lat())) * Math.sin(dLong / 2) * Math.sin(dLong / 2)
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  d = R * c
  d
  # returns the distance in meter

$(document).ready ready
