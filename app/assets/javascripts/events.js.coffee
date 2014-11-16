$ ->
  $("a[data-reveal-id=create-event]").click ->
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

  $('[data-behaviour=select-template]').change ->
    url = $(this).val()
    if url
      $.getJSON url, (data) ->
        console.log data
        $('#preview').val(data.body)
    else
      $('#preview').val('')
