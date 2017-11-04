class Question < ApplicationRecord
  include Attachable
  include HasUser
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  scope :created_yesterday, -> { where(created_at: 1.day.ago..Time.zone.now) }

  after_create :subscribe_author

  private

  def subscribe_author
    subscriptions.create(user_id: user.id)
  end
end
