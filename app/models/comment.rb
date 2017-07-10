class Comment < ApplicationRecord
  include HasUser

  belongs_to :commentable, polymorphic: true, optional: true

  validates :body, presence: true

  scope :on_created_at, -> { order(created_at: :asc) }
end
