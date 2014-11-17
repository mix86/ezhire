# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  person_id = $('table').data('selectedPerson')
  if person_id
    modal = $ "#show-person-#{person_id}"
    modal.foundation('reveal', 'open')

  $("[data-behaviour=show-advanced-search]").click ->
    $('#advanced-search').show()
    false
