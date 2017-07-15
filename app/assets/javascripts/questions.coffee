ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

  return if App.questions
  App.questions = App.cable.subscriptions.create 'QuestionsChannel',
    received: (data) ->
      return if data.user_id
      $('.questions-list').append(data)

$(document).ready(ready)
$(document).on('page-load', ready)
$(document).on('page-update', ready)
$(document).on('turbolinks:load', ready)
