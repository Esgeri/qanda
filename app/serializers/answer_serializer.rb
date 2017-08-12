class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :best, :rating
  has_many :attachments
  has_many :comments
end
