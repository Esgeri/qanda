subscribeToComments = ->
  return if App.comments
  App.comments = App.cable.subscriptions.create 'CommentsChannel',
    received: (data) ->
      return if gon.user_id == data.user_id
      comments = '.comments-' + data.commentable_type.toLowerCase() + '-' + data.commentable_id
      $(comments).append("<p class='comment_body'>" + data.body + "</p>")

$(document).on('turbolinks:load', subscribeToComments)
