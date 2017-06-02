class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true
  has_many :attachments, as: :attachmentable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :on_top, -> { order(best: :desc, created_at: :desc) }

  def set_best
    Answer.transaction do
      self.question.answers.where.not(id: self).update_all(best: false)
      self.update!(best: true)
    end
  end
end
