# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:receive', ->
  tinymce.remove()
$(document).on 'ready page:load', ->
  tinyMCE.init ->
    selector: "textarea.tinymce"
    return
  return