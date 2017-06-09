class Answer < ApplicationRecord
  include Attachable
  include HasUser
  include Votable

  belongs_to :question

  validates :body, presence: true

  scope :on_top, -> { order(best: :desc, created_at: :asc) }

  def set_best
    Answer.transaction do
      self.question.answers.where.not(id: self).update_all(best: false)
      self.update!(best: true)
    end
  end
end
