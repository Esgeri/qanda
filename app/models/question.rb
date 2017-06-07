class Question < ApplicationRecord
  include Attachable
  include HasUser
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
