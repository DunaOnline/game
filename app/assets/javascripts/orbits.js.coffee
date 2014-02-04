# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  if $(".select_orbit").attr("href") == 'orbits'
    $(".select_orbit").attr("href", 'orbits?planet='+$("#orbits_select").val())
    $("#orbits_select").change ->
      $(".select_orbit").attr("href", '?planet='+$(this).val())
  else
    $(".select_orbit").attr("href", $("#orbits_select").val())
    $("#orbits_select").change ->
      $(".select_orbit").attr("href", $(this).val())