ready = ->
  $('body').on 'click', '.add-comment-link', (e) ->
    e.preventDefault()
    $(this).hide()
    commentableId = $(this).data('commentableId')
    commentableClass = $(this).data('commentableClass')
    $('form#new-' + commentableClass + '-' + commentableId + '-comment').show()

  $('body').on 'ajax:success', '.new-comment', (e, data, status, xhr) ->
    comment = xhr.responseJSON
    comments = '.comments-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id
    $(comments).append('<p comment_body>' + comment.body + '</p>')
    $('.comment-errors').html('')
    $('.new-comment-body').val('')
    $('form#new-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id + '-comment').hide()
    $('.add-comment-link').show()
  .on 'ajax:error', '.new-comment', (e, xhr, status, error) ->
    errors = xhr.responseJSON.errors
    $.each errors, (index, value) ->
      $('.comment-errors').html('<p>' + value + '</p>')

  App.cable.subscriptions.create({channel: 'CommentsChannel', question_id: gon.question_id}, {
    received: (data) ->
      return if gon.user_id == data.user_id
      comments = '.comments-' + data.commentable_type.toLowerCase() + '-' + data.commentable_id
      $(comments).append("<p class='comment_body'>" + data.body + "</p>")
  })

$(document).on('turbolinks:load', ready)
