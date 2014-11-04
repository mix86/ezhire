# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

showEditor = (r) ->
  id = r.data('id')
  r.find('td.editor').show()
  r.find('td.editable').hide()

submitRow = (r) ->
  $form = r.find('form')
  r.find('input,select').each (i, e) ->
    $form.append $(e)
  $form.submit()

$ ->
  $('table.editable [data-behaviour=show-editor]').not('.actions').click ->
    showEditor $(this).parents('tr')
    false

  $('table.editable a[data-behaviour=submit-row]').click ->
    row = $(this).parents('tr')
    submitRow row
    false
