App.answers = App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      question_id = $('.question').data('id')
      @perform 'subscribe', question_id: question_id
    ,

    received: (data) ->
      console.log 'received', data
      console.log('Gon.question_id: ', gon.question_id)
      console.log('Gon.question_user_id:', gon.question_user_id)
      console.log('User id: ', gon.user_id)
      console.log('Answer id: ', data.id)

      $('.answers').append JST['skim_templates/answer'](data)

      # $('.answers').append JST['skim_templates/answer'](data['answer'])
      # json = $.parseJSON(data)
      # answer = json.answer
      # console.log('Data answer user id: ', data.answer.user_id)
      # $('.answers').append JST['skim_templates/answer']({answer: answer})
  })
