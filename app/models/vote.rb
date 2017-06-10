class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true, optional: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
end
