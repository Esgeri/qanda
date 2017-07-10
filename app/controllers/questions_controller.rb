class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :set_gon_variable, only: [:show]
  before_action :build_answer, only: [:show]
  before_action :verify_authorship, only: [:edit, :update, :destroy]

  after_action :publish_question, only: [:create]

  include PublicAccess
  include Votes

  respond_to :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit; end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def verify_authorship
    unless current_user.author_of?(@question)
      flash[:error] = 'You have no permission to do this action'
      redirect_to questions_path
    end
  end

  def build_answer
    @answer = @question.answers.build
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def set_gon_variable
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
