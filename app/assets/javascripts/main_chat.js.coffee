$ ->
  socket = new WebSocket "ws://#{window.location.host}/notifications/chat"

  console.log socket

  socket.onmessage = (event) ->
    alert(event.data)
