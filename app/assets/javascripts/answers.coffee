ready = ->
  $('body').on 'click', '.edit-answer-link', (e) ->
  # $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $("form#edit-answer-#{answer_id}").show()

  App.cable.subscriptions.create({channel: 'AnswersChannel', question_id: gon.question_id}, {
    received: (data) ->
      return if gon.user_id == data.answer.user_id
      $('.answers').append(JST['skim_templates/answer'](data))
  })

$(document).on('turbolinks:load', ready)
