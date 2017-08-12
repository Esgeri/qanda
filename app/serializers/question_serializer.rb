class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :rating

  has_many :attachments
  has_many :comments
end
