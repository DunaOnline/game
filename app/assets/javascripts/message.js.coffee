
#$(document).ready ->
#  $("#new_postum").on("ajax:success", (e, data, status, xhr) ->
#    response = xhr.responseJSON
##    $("#notation").html("")
##    $("#notation").fadeIn()
##    $("#notation").append("Posta odoslana")
#
#
#
#  )
#  .bind "ajax:error", (e, xhr, status, error) ->
#      alert("error")
#      $("#new_postum").append xhr.responseText
#  .bind "ajax:complete", (evt, xhr, status) ->
#      $("#notation").fadeOut(1500)
#      $form = $(this)
#      $form.find('textarea,input[type="text"],input[type="file"]').val("")

$(document).ready ->
  $(".message").click ->
    $(this).parent().parent().next().toggle(200)
    $("tr.postaBody").not($(this).parent().parent().next()).hide();



  messages = $(".opica")
  pagination(messages)

  $(".filterPosta").each ->
    $(this).click ->
      messages.fadeOut ->
      druh = this.innerText.substr(0,1)
      if druh == "S" then pagination(messages) else pagination($('tr[data-druh='+druh+']'))

#      filter(druh)

#filter = (druh) ->
#
#  $('tr[data-druh='+druh+']').each ->
#    $(this).fadeIn 'slow'
messagesToShow = (page,messages) ->
  pageEnd = page*10
  if page == 1 then pageBeg = 1 else pageBeg = page*10-10
  messages_to_show = messages[pageBeg...pageEnd]
  messages_to_show.each ->
    $(this).fadeIn 'slow'
pagination = (messages) ->
  messages = messages
  count = messages.length
  pages = count / 10 + 1
  page = 1
  messages[0...10].each ->
    $(this).fadeIn 'slow'
  $('.pageNumber').each ->
    $(this).remove()
  page = for number in [1...Math.round(pages)] when Math.round(pages) > 1
#    if number == 2 then $("#pagination").append("<span class='pageNumber'>"+1+"</span>")

    $("#pagination").append("<span class='pageNumber'>"+number+"</span>")
  $(".pageNumber").first().addClass("selected")
  $(".pageNumber").each ->
    $(this).click ->
      messages.fadeOut ->
      messagesToShow(parseInt(this.innerText,10),messages)
      if $(".selected") then $(".selected").removeClass('selected')
      $(this).addClass("selected")

