$ ->
  $("a[data-reveal-id=createEvent]").click ->
    $this = $(this)
    personId = $this.data('personId')
    parentEvent = $this.data('parentEvent')
    $("#event_person").val(personId)
    $("#parentEvent").val(parentEvent)

  $('.datetime-selector a').click ->
    date = $(this).data('date')
    time = $(this).data('time')
    $(this).parents('.datetime-selector').find('.date-input').val(date)
    $(this).parents('.datetime-selector').find('.time-input').val(time)
    false
