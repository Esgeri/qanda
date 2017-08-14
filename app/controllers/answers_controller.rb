class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:update, :destroy, :mark_best]

  after_action :publish_answer, only: [:create]

  include Votes

  respond_to :js

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def mark_best
    respond_with(@answer.set_best)
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("answers-question-#{@question.id}",
      answer: @answer,
      rating: @answer.rating,
      attachments: @answer.attachments
    )
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
