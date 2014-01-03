# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $(".prevent_def").click (event)->
    event.preventDefault()
  $(".hide_fields").click ->
    $("." + $(this).parent().parent().attr('id')).toggle(500)