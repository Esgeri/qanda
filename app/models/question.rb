class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
end
