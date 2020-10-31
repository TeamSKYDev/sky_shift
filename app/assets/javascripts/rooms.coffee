# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'change', '#room_store_id', ->
  $.ajax(
    type: 'GET'
    url: '/rooms/get_users'
    data: {
      store_id: $(this).val()
    }
  ).done (data) ->
    $('.users-checkbox').html(data)
  
  

$(document).on 'turbolinks:load', ->
  $('button.list-group-item').on 'click', ->
    $.ajax(
      type: 'GET'
      url: '/rooms/get_rooms'
      data: store_id: $(this).attr('id')).done (data) ->
      # console.log(data);
      $('.select-room').html data

# $(document).on 'turbolinks:load', ->
#   $('#back-arrow').on 'click', ->
#     console.log("click")
#     $('.select-room').html()