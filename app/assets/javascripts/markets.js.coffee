# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $("#offerForm").fadeOut()
  $("#newOffer").click ->
    $("#offerForm").toggle(500)


  $("#market_area").click ->
    area = $(this).val()
    switch area
      when "M" then $("#market_amount").attr("step", "any")
      when "J" then $("#market_amount").attr("step", "any")
      when "E" then $("#market_amount").removeAttr("step")
      when "P" then $("#market_amount").removeAttr("step")
  #      switch area
  #      when "M" then $("#market_amount").attr("step","any")
  #      when "J"
  #      when "E"
  #      when "P"
  #
  #      else
  #        $("#market_amount").removeAttr("step")
  $(".vyroba #q").each ->
    $(this).next().attr('disabled', 'disabled')
    $(this).click ->
      $(this).keyup()
    $(this).keyup ->
      if $(this).val == "" then $(this).next().attr('disabled', 'disabled') else $(this).next().removeAttr('disabled')

