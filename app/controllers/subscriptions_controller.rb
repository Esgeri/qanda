class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @subscription = @question.subscriptions.create(user: current_user)
    redirect_to @question, notice: 'You are successfully subscribed to the question.'
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    redirect_to @subscription.question, notice: 'You have successfully unsubscribed from the question.'
  end
end
