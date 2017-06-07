class Question < ApplicationRecord
  include Attachable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
end
