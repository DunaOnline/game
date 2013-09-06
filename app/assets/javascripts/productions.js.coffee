# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $(".select_tovaren").attr("href", $("#lena").val())
  $("#lena").change ->
    $(".zobraz_tovaren").attr("href", $(this).val())
  $(".titel").click ->
    $(this).parent().next().toggle(500)

