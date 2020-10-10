# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.change_display_buttun').on 'click', ->
    $('.second_display').css 'display', 'block'
    $('.first_display').css 'display', 'none'
    return
  return

$ ->
  $('.return_display_buttun').on 'click', ->
    $('.second_display').css 'display', 'none'
    $('.first_display').css 'display', 'block'
    return
  return