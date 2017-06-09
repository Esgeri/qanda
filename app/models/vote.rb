class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true, optional: true
  belongs_to :user

  validates :is_liked, uniqueness: { scope: [:user_id, :votable_id, :votable_type] }
end
