class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:destroy]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    respond_to do |format|
      format.js { render @answer.save ? 'create' : 'errors' }
      format.html do
        @answer.save ? redirect_to(@question) : render('questions/show')
      end
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
    end
    redirect_to @answer.question
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
