# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  if $(".select_squad").attr("href") == 'leno/'
    $(".select_squad").attr("href", '?leno='+$("#lena_squad").val())
    $("#lena_squad").change ->
      $(".select_squad").attr("href", '?leno='+$(this).val())
  else
    $(".select_squad").attr("href", $("#lena_squad").val())
    $("#lena_squad").change ->
      $(".select_squad").attr("href", $(this).val())