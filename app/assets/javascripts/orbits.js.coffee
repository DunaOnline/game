# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $(".select_orbit").attr("href", '?planet='+$("#orbits_select").val())
  $("#orbits_select").change ->
    $(".select_orbit").attr("href", '?planet='+$(this).val())
