class Question < ApplicationRecord
  include Attachable
  include HasUser
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  scope :created_yesterday, -> { where(created_at: 1.day.ago..Time.zone.now) }
end
