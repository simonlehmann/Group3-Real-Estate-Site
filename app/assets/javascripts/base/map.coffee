map = undefined
geocoder = undefined

# Moved into one ready function to be called across page load and document.ready as discussed on Slack
ready = ->
  # To remove the console error, I'm only running this on the maps page
  loc = window.location.pathname
  console.log loc
  if loc.includes('map')
    #Declare variables/arrays etc
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

  return

# Convert Address into lat and long and show on map
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

# Turbolinking only runs the $(document).ready on initial page load. 
# So we need to assign 'ready' to both document.ready and page:load (which is a turboscript thing)
$(document).ready ready
$(document).on 'page:load', ready