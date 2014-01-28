$ ->
  socket = new WebSocket "ws://#{window.location.host}/notifications/chat"

  recipient = $('.recipient').data 'user-id'

  socket.onmessage = (event) ->
    console.log(event.data)

  $('button[type=submit]').click ->
    text = $('.msg-area').val()
    $('.msg-area').val ""
    data = JSON.stringify({message: text, event:"send_message", recipients: [recipient]})
    socket.send(data)
