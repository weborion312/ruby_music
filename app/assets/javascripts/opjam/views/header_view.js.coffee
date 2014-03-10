$(document).ready ->
  $(".add-new").hover (->
    $(".dropdown").fadeIn()
  ), ->
    $(".dropdown").fadeOut()
  
    $.backstretch "http://labs.twelveohsixcreative.com/opjam/images/bg-2.jpg"
    $(".contract").click ->
      $("#left-panel").slideUp "slow"
      $(".expand").fadeIn "slow"
      $(".contract").fadeOut "fast"
      false

    $(".expand").click ->
      $("#left-panel").slideDown "slow"
      $(".contract").fadeIn "slow"
      $(".expand").fadeOut "fast"
      false

    $("a.close").click ->
      $(".overlay").fadeOut "normal"
      $(".popup").fadeOut "normal"
      false

    $("#signin-open").click ->
      $(".overlay").fadeIn "normal"
      $(".popup").fadeIn "normal"
      false
    