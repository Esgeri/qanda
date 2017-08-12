class Api::V1::AnswersController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:index, :show, :create]

  before_action :load_question, except: :show

  authorize_resource

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer, each_serializer: AnswersListSerializer
  end

  def index
    @answers = @question.answers
    respond_with @answers
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_resource_owner.id))
    respond_with @answer
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
