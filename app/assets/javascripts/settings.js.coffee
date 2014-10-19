$ ->
  $('a[data-behaviour=new-question]').click ->
    block = $(this).parents('.question-answer')
    rows = block.find('.rows')
    template = rows.find('.row:last').clone()

    template.find('span.question').text('Вопрос')
    template.find('input[type=hidden]').attr('type', 'text')
    template.find('input').val('')
    template.find('textarea').val('')
    rows.append(template)
    false

