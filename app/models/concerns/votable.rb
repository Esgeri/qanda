module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    accepts_nested_attributes_for :votes
  end

  def like_by(user)
    unless voted_by?(user)
      votes.create(is_liked: true, user: user)
      self.rating += 1
      self.save
    end
  end

  def dislike_by(user)
    unless voted_by?(user)
      votes.create(is_liked: false, user: user)
      self.rating -= 1
      self.save
    end
  end

  def unvote(user)
    if voted_by?(user)
      vote = votes.where(user: user).first
      vote.is_liked ? self.rating -= 1 : self.rating += 1
      vote.destroy
    end
  end

  def voted_by?(user)
    user.votes.exists?(votable_id: id, votable_type: self.class.name)
  end
end
