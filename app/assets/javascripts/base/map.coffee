# Declare current location variable for use
currentLocation = undefined

# On page ready, continue with this code
ready = ->
  # Check if a map canvas exists
  if $('#map-canvas').length
    # Get the properties address
    location_addr = $('#map-canvas').data('addr')
    # Initiate a new instance of geocoder
    geocoder = new (google.maps.Geocoder)
    # Conver the address into lat and lng values and store in currentLocation
    geocodeAddress(location_addr, geocoder)

    $('.map-buttons .dropdown.button').dropdown
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
      alert 'Geocode was not successful for the following reason: ' + status
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

$(document).ready ready