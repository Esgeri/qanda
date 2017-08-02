class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment, only: [:create]

  respond_to :json, only: [:create]

  authorize_resource

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
    respond_with(@comment, location: @commentable, status: :ok)
  end

  private

  def publish_comment
    return if @comment.errors.any?

    question_id = @comment.commentable_type == 'Question' ? @comment.commentable.id : @comment.commentable.question.id

    ActionCable.server.broadcast("comments-question-#{question_id}", @comment)
  end

  def set_commentable
    model_klass = [Question, Answer].find { |c| params["#{c.name.underscore}_id"] }
    @commentable = model_klass.find(params["#{model_klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
