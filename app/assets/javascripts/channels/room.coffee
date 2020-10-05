document.addEventListener 'turbolinks:load', ->
  if App.room
    App.cable.subscriptions.remove App.room
  App.room = App.cable.subscriptions.create { channel: "RoomChannel", room: $('#messages').data('room_id') },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      $('#message-box .card-body').append data['message']
      $('.messages').animate scrollTop: $('.messages')[0].scrollHeight
      # Called when there's incoming data on the websocket for this channel

    speak: (message) ->
      @perform 'speak', message: message

  $('#chat-input').on 'keypress', (event) ->
    #return キーのキーコードが13
    if event.keyCode is 13
      #speakメソッド,event.target.valueを引数に.
      App.room.speak event.target.value
      event.target.value = ''
      event.preventDefault()