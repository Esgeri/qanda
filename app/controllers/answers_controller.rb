class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:new, :create, :destroy]
  before_action :load_answer, only: [:update, :destroy, :mark_best]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    render @answer.save ? 'create' : 'errors'
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
    if current_user.author_of?(@answer)
      @answer.set_best
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
