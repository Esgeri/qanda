class AnswersController < ApplicationController
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:update, :destroy, :mark_best]
  after_action :publish_answer, only: [:create]

  include PublicAccess
  include Votes

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def mark_best
    @question = @answer.question
    if current_user.author_of?(@question)
      @answer.set_best
    end
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast('answers',
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
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
