ready = ->
  getLocation = ->
    if navigator.geolocation
      options = timeout: 60000
      navigator.geolocation.getCurrentPosition showPosition, showError, options
    else
      console.log 'Geolocation is not supported by this browser.'
      setDefaultImage()
    return

  showPosition = (position) ->
    lat_lng = 
      lat: position.coords.latitude
      lng: position.coords.longitude
    getAddress(lat_lng)
    return

  getAddress = (lat_lng) ->
    result_address = undefined
    latlng = new (google.maps.LatLng)(lat_lng.lat, lat_lng.lng)
    geocoder = geocoder = new (google.maps.Geocoder)
    geocoder.geocode { 'latLng': latlng }, (results, status) ->
      if status == google.maps.GeocoderStatus.OK
        if results[1]
          result_address = results[1].formatted_address
          getState(result_address)
      return
    return
  
  getState = (address) ->
    address_split = address.split(',')
    state_split = address_split[1].split(' ')
    state = state_split[2]
    changeImage(state)
    return

  changeImage = (state) ->
    if state.includes('WA')
      $('.search-section').addClass 'perth-img'
    else if state.includes('MEL')
      $('.search-section').addClass 'melb-img'
    else
      $('.search-section').addClass 'perth-img'
    return

  setDefaultImage = ->
    $('.search-section').addClass 'perth-img'
    return

  showError = (error) ->
    if error != null
      switch error.code
        when error.PERMISSION_DENIED
          console.log 'User denied the request for Geolocation.'
          setDefaultImage()
        when error.POSITION_UNAVAILABLE
          console.log 'Location information is unavailable.'
          setDefaultImage()
        when error.TIMEOUT
          console.log 'The request to get user location timed out.'
          setDefaultImage()
        when error.UNKNOWN_ERROR
          console.log 'An unknown error occurred.'
          setDefaultImage()
    else
      alert 'null'
      return
    return
  
  getLocation()

$(document).ready ready
$(document).on 'page:load', ready