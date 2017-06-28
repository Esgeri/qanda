subscribeToQuestions = ->
  return if App.questions
  App.questions = App.cable.subscriptions.create 'QuestionsChannel',
    received: (data) ->
      return if data.user_id
      $('.questions-list').append(data)

$(document).on('turbolinks:load', subscribeToQuestions)
