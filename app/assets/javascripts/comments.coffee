ready = ->
  $('body').on 'click', '.add-comment-link', (e) ->
    e.preventDefault()
    $(this).hide()
    commentableId = $(this).data('commentableId')
    commentableClass = $(this).data('commentableClass')
    $('form#new-' + commentableClass + '-' + commentableId + '-comment').show()

  $('body').on 'ajax:success', '.new-comment', (e, data, status, xhr) ->
    comment = xhr.responseJSON.comment
    comments = '.comments-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id
    $(comments).append('<p comment_body>' + comment.body + '</p>')
    $('.comment-errors').html('')
    $('.new-comment-body').val('')
    $('form#new-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id + '-comment').hide()
    $('.add-comment-link').show()
  .on 'ajax:error', '.new-comment', (e, xhr, status, error) ->
    errors = xhr.responseJSON
    $.each errors, (index, value) ->
      $('.comment-errors').html('<p>' + value + '</p>')

$(document).on('turbolinks:load', ready)
