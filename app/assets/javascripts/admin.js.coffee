$(document).ready ->
  $(".pridej_suroviny").attr("disabled", "true")
  $("#komu_hraci").change ->
    $(".pridej_suroviny").removeAttr("disabled")
    if $(this).is(':checked') then $(".suroviny_narodu").hide(-> $(".suroviny_hraci").show())


  $("#komu_rodu").change ->
    $(".pridej_suroviny").removeAttr("disabled")
    if $(this).is(':checked') then $(".suroviny_hraci").hide(-> $(".suroviny_narodu").show())

