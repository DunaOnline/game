# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $("#offerForm").fadeOut()
  $("#newOffer").click ->
    $("#offerForm").toggle(500)



  $(".vyroba #q").each ->
    $(this).next().attr('disabled', 'disabled')
    $(this).click ->
      $(this).keyup()
    $(this).keyup ->

      if $(this).val == "" then $(this).next().attr('disabled', 'disabled') else $(this).next().removeAttr('disabled')

