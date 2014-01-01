$ ->
  socket = new WebSocket "ws://#{window.location.host}/notifications/chat"

  socket.onmessage = (event) ->
    console.log(event.data)
