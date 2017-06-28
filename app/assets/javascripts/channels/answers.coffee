subscribeToAnswers = ->
  return if App.answers
  App.answers = App.cable.subscriptions.create 'AnswersChannel',
    received: (data) ->
      return if gon.user_id == data.answer.user_id
      $('.answers').append(JST['skim_templates/answer'](data))

$(document).on('turbolinks:load', subscribeToAnswers)
