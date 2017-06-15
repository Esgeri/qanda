ready = ->
  $('.like, .dislike, .cancel_vote').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    if(response.status == 200)
      $('.question-errors').empty()
      $('.question-rating-' + response.id).html('Rating: ' + response.rating)
    else
      $('.question-errors').html(response.data)
  .bind 'ajax:error', (e, status, xhr, error) ->
    response = $.parseJSON(xhr.responseText)
    $('.question-errors').html(response.data)

$(document).on('click', '.edit-question-link', (e) ->
  e.preventDefault()
  $(this).hide()
  question_id = $(this).data('questionId')
  $('form#edit-question-' + question_id).show()
)

$(document).ready(ready)
$(document).on('page-load', ready)
$(document).on('page-update', ready)
$(document).on('turbolinks:load', ready)
