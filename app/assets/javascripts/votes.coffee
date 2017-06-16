ready = ->
  $('.like, .dislike, .cancel_vote').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.question-rating-' + response.id).html('Rating: ' + response.rating)
    $('.question-errors').empty()
    $('.answer-rating-' + response.id).html('Rating: ' + response.rating)
    $('#answer-' + response.id + '.answer-errors').empty()
  .bind 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $('.question-errors').html(response.data)
    $('#answer-' + response.id + '.answer-errors').html(response.data)

$(document).ready(ready)
$(document).on('page-load', ready)
$(document).on('page-update', ready)
$(document).on('turbolinks:load', ready)
