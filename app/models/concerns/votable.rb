module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    accepts_nested_attributes_for :votes
  end

  def like_by(user)
    self.votes.create(value: 1, user: user)
  end

  def dislike_by(user)
    self.votes.create(value: -1, user: user)
  end

  def unvote(user)
    self.votes.where(user: user).delete_all
  end

  def rating
    votes.sum(:value)
  end

  def voted_by?(user)
    user.votes.exists?(votable_id: id, votable_type: self.class.name)
  end
end
