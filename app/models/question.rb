class Question < ApplicationRecord
  include Attachable
  include HasUser
  include Votable

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
