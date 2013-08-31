$(document).ready ->
  $("#message_druh").click ->
    if $(this).val() != ""
      $("#message_recipients").attr("disabled", "disabled")
      $("#message_recipients").val("")
      $("#message_recipients").attr("placeholder", $(this).children("option").filter(":selected").text())
    else
      $("#message_recipients").removeAttr("disabled")
      $("#message_recipients").attr("placeholder", "Adresat")
  $(".message").click ->
    $(this).closest("tr").find(".precitana").click()
    if $(this).parent().find(".precitanaimg") then $(this).parent().find(".precitanaimg").hide()
    $(this).parent().parent().next().toggle(200)
    $("tr.postaBody").not($(this).parent().parent().next()).hide();


  messages = $(".opica")
  pagination(messages)

  $(".filterPosta").each ->
    $(this).click ->
      messages.fadeOut ->
      $(".druhPosty").empty()
      $(".druhPosty").append(this.innerText)
      druh = this.innerText.substr(0, 1)
      if druh == "S" then pagination(messages) else pagination($('tr[data-druh=' + druh + ']'))


messagesToShow = (page, messages) ->
  pageEnd = page * 10
  if page == 1 then pageBeg = 1 else pageBeg = page * 10 - 10
  messages_to_show = messages[pageBeg...pageEnd]
  messages_to_show.each ->
    $(this).fadeIn 'slow'

pagination = (messages) ->
  messages = messages
  count = messages.length
  pages = count / 10
  page = 1
  messages[0...10].each ->
    $(this).fadeIn 'slow'
  $('.pageNumber').each ->
    $(this).remove()
  page = for number in [1..Math.ceil(pages)] when Math.ceil(pages) > 1
    # if number == 2 then $("#pagination").append("<span class='pageNumber'>"+1+"</span>")

    $("#pagination").append("<span class='pageNumber'>" + number + "</span>")
  $(".pageNumber").first().addClass("selected")
  $(".pageNumber").each ->
    $(this).click ->
      $("tr.postaBody").hide()
      messages.fadeOut ->
      messagesToShow(parseInt(this.innerText), messages)
      if $(".selected") then $(".selected").removeClass('selected')
      $(this).addClass("selected")

