class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      format.json do
        if @comment.save
          render json: { comment: @comment }, status: :ok
        else
          render json: @comment.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast('comments', @comment)
  end

  def set_commentable
    model_klass = [Question, Answer].find { |c| params["#{c.name.underscore}_id"] }
    @commentable = model_klass.find(params["#{model_klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end