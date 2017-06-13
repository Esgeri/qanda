ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('.like, .dislike, .cancel_vote').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    if(response.status == 'success')
      $('#answer-' + response.id + '.answer-errors').empty()
      $('.answer-rating-' + response.id).html('Rating: ' + response.rating)
    else
      $('#answer-' + response.id + '.answer-errors').html(response.data)

$(document).ready(ready)
$(document).on('page-load', ready)
$(document).on('page-update', ready)
$(document).on('turbolinks:load', ready)
