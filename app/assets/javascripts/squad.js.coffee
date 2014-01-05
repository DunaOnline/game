# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $(".select_squad").attr("href", 'squads/'+$("#lena_squad").val())
  $("#lena_squad").change ->
    $(".select_squad").attr("href", 'squads/'+$(this).val())