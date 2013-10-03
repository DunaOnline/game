# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  if !$("#market_area").val() then $("#market_area").parent().parent().find("input").attr('disabled', 'disabled')
  $("#offerForm").fadeOut()
  $("#newOffer").click ->
    $("#offerForm").toggle(500)


  $("#market_area").click ->
    area = $(this).val()

    switch area
      when "M" then $("#market_amount").attr("step", "any").attr("min", "0.1")
      when "J" then $("#market_amount").attr("step", "any").attr("min", "0.1")
      when "E" then $("#market_amount").removeAttr("step") $("#market_amount").attr("min", "1")
      when "P" then $("#market_amount").removeAttr("step") $("#market_amount").attr("min", "1")
      else
        $("#market_amount").removeAttr("step").attr("min", "1")

  $(".vyroba #q").each ->
    $(this).next().attr('disabled', 'disabled')
    $(this).click ->
      $(this).keyup()
    $(this).keyup ->
      if $(this).val == "" then $(this).next().attr('disabled', 'disabled') else $(this).next().removeAttr('disabled')

