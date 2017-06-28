ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

$(document).ready(ready)
$(document).on('page-load', ready)
$(document).on('page-update', ready)
$(document).on('turbolinks:load', ready)
