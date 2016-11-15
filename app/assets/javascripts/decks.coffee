# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

    

  
$(document).on 'ready page:load', ->
    $(".card-wrapper").on "click", "#show", (event) ->
        event.preventDefault()
        $(".card-bottom").addClass("card-bottom-visible")
        $(".card-bottom").removeClass("card-bottom-hidden")
        return
    return
    
$(document).on 'ready page:load', ->
    $("#forgot").hide()
    $("#remembered").hide()
    return
    
$(document).on 'ready page:load', ->
    $(".card-wrapper").on "click", "#show", (event) ->
        event.preventDefault()
        $("#show").hide()
        $("#forgot").show()
        $("#remembered").show()
    return
    
$(document).on 'ready page:load', ->
    $(".card-wrapper").on "click", "#remembered", (event) ->
        event.preventDefault()
        $(".success-inlay").addClass("inlay-remembered")
    return

$(document).on 'ready page:load', ->
    $(".card-wrapper").on "click", "#forgot", (event) ->
        event.preventDefault()
        $(".fail-inlay").addClass("inlay-forgot")
    return
    
