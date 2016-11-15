$(document).on 'ready page:load', ->
  $("#hide-word").click ->
    $(".word-list").css('color', 'white')
    
  $("#show-word").click ->
    $(".word-list").css('color', '#333')
    
  $("#hide-hiragana").click ->
    $(".hiragana-list").css('color', 'white')
    
  $("#show-hiragana").click ->
    $(".hiragana-list").css('color', '#333')
    
  $("#hide-reading").click ->
    $(".reading-list").css('color', 'white')
    
  $("#show-reading").click ->
    $(".reading-list").css('color', '#333')
    
  $("#hide-translation").click ->
    $(".translation-list").css('color', 'white')
    
  $("#show-translation").click ->
    $(".translation-list").css('color', '#333')
    
  $("#hide-all-words").click ->
    $(".word-list").css('color', 'white')
    $(".hiragana-list").css('color', 'white')
    $(".reading-list").css('color', 'white')
  
  $("#show-all-words").click ->
    $(".word-list").css('color', '#333')
    $(".hiragana-list").css('color', '#333')
    $(".reading-list").css('color', '#333')
  


