class Subscription < ApplicationRecord
  include HasUser

  belongs_to :question, optional: true

  validates :user_id, :question_id, presence: true
  validates :user_id, uniqueness: { scope: :question_id }
end
