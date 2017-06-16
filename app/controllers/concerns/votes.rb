module Votes
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:set_like, :set_dislike, :cancel_vote]
    before_action :check_author_of, only: [:set_like, :set_dislike, :cancel_vote]
  end

  def set_like
    if has_vote?
      render json: { data: 'You can vote only once!' }, status: 403
    else
      @votable.like_by(current_user)
      render json: { id: @votable.id, rating: @votable.rating },  status: 200
    end
  end

  def set_dislike
    if has_vote?
      render json: { data: 'You can vote only once!' }, status: 403
    else
      @votable.dislike_by(current_user)
      render json: { id: @votable.id, rating: @votable.rating }, status: 200
    end
  end

  def cancel_vote
    if has_vote?
      @votable.unvote(current_user)
      render json: { id: @votable.id, rating: @votable.rating }, status: 200
    else
      render json: { data: 'Need vote first!' }, status: 403
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def check_author_of
    if current_user.author_of?(@votable)
      render json: { data: 'You can not vote. Because you owner!' }, status: 403
    end
  end

  def has_vote?
    @votable.votes.find_by(user: current_user)
  end
end
