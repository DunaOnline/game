#$(document).ready ->
#  $(".vylepsiTech").on("ajax:success", (e, data, status, xhr) ->
#    response = xhr.responseText
#    alert(response)
#
#
#  ).bind "ajax:error", (e, xhr, status, error) ->
#    $("#flash_error").html(error)
#    alert xhr.responseText
#  .bind "ajax:complete", (evt, xhr, status) ->
#      $form = $(this)
#      $form.find('textarea,input[type="text"],input[type="file"]').val("")
#      alert "koniec"
#
#
#
#
#
#
#
#
#
$(document).on 'click', '#descr', ->
  $(this).parent().next().toggle()