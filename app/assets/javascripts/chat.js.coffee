show_map = (position) ->
  latitude = position.coords.latitude
  longitude = position.coords.longitude

  console.log "Latitude #{latitude} Longitude #{longitude}"


  $('#location_latitude').val latitude
  $('#location_longitude').val longitude

$ ->
  navigator.geolocation.getCurrentPosition show_map;


