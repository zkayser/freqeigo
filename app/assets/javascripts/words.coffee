# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



$(document).on 'ready page:load', ->
    $("#study-list-wrapper").on "click", "#toggle-word", (event) ->
        event.preventDefault()
        toggleButton($(this))
        $(".word-list").toggleClass("white-out")
        return
    return
    
$(document).on 'ready page:load', ->
    $("#study-list-wrapper").on "click", "#toggle-hiragana", (event) ->
        event.preventDefault()
        toggleButton($(this))
        $(".hiragana-list").toggleClass("white-text")
        return
    return

$(document).on 'ready page:load', ->
    $("#study-list-wrapper").on "click", "#toggle-reading", (event) ->
        event.preventDefault()
        toggleButton($(this))
        $(".reading-list").toggleClass("white-text")
        return
    return
    
$(document).on 'ready page:load', ->
    $("#study-list-wrapper").on "click", "#toggle-synonyms", (event) ->
        event.preventDefault()
        toggleButton($(this))
        $(".synonym-list").toggleClass("white-text")
        return
    return
    
$(document).on 'ready page:load', ->
    $("#study-list-wrapper").on "click", "#toggle-antonyms", (event) ->
        event.preventDefault()
        toggleButton($(this))
        $(".antonym-list").toggleClass("white-text")
        return
    return
    
$(document).on 'ready page:load', ->
    $("#study-list-wrapper").on "click", "#toggle-priority", (event) ->
        event.preventDefault()
        toggleButton($(this))
        $(".priority-list").toggleClass("white-text")
        return
    return
    
$(document).on 'ready page:load', ->
    $("#study-list-wrapper").on "click", "#toggle-translations", (event) ->
        event.preventDefault()
        toggleButton($(this))
        $(".translation-list").toggleClass("white-text")
        return
    return
    
$(document).on 'ready page:load', ->
    $("#study-list-wrapper").on "click", "#toggle-word-list", (event) ->
        event.preventDefault()
        toggleButton($(this))
        alignClasses($(this)) 
        return
    return
    
$(document).on 'ready page:load', ->
    $("#study-list-wrapper").on "click", "#toggle-word-attributes", (event) ->
        event.preventDefault()
        toggleButton($(this))
        alignWithoutWord($(this))
        verifyKanjiDisplay()
        return
    return
    
$(document).on 'ready page:load', ->
    $(".word-list").popover()
    
    
toggleButton = (button) ->
    if button.hasClass('btn btn-primary')
        button.removeClass('btn-primary')
        button.addClass('btn-success')
    else if button.hasClass('btn btn-success')
        button.removeClass('btn-success')
        button.addClass('btn-primary')
       

alignClasses = (button) ->
    if button.hasClass('btn btn-primary')
        $(".word-list").removeClass("white-out")
        $(".hiragana-list").removeClass("white-text")
        $(".reading-list").removeClass("white-text")
        $(".synonym-list").removeClass("white-text")
        $(".antonym-list").removeClass("white-text")
        $(".priority-list").removeClass("white-text")
    else
        $(".word-list").addClass("white-out")
        $(".hiragana-list").addClass("white-text")
        $(".reading-list").addClass("white-text")
        $(".synonym-list").addClass("white-text")
        $(".antonym-list").addClass("white-text")
        $(".priority-list").addClass("white-text")
        
alignWithoutWord = (button) ->
    if button.hasClass('btn btn-primary')
        $(".hiragana-list").removeClass("white-text")
        $(".reading-list").removeClass("white-text")
        $(".synonym-list").removeClass("white-text")
        $(".antonym-list").removeClass("white-text")
        $(".priority-list").removeClass("white-text")
    else
        $(".hiragana-list").addClass("white-text")
        $(".reading-list").addClass("white-text")
        $(".synonym-list").addClass("white-text")
        $(".antonym-list").addClass("white-text")
        $(".priority-list").addClass("white-text")
        
verifyKanjiDisplay = ->
    if $(".word-list").hasClass("white-out")
        $(".word-list").removeClass("white-out")
        
 
# Data table function for admin page.
$(document).on 'ready page:load', ->
    $("#admin-words").dataTable(
        sPaginationType: "full_numbers"
        bProcessing: true
        bServerSide: true
        sAjaxSource: $('#admin-words').data('source')
        )

  