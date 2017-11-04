class Answer < ApplicationRecord
  include Attachable
  include HasUser
  include Votable
  include Commentable

  belongs_to :question

  validates :body, presence: true

  scope :on_top, -> { order(best: :desc, created_at: :asc) }

  after_commit :send_notify, on: :create

  def set_best
    Answer.transaction do
      self.question.answers.where.not(id: self).update_all(best: false)
      self.update!(best: true)
    end
  end

  private

  def send_notify
    AnswersNotifierJob.perform_later(self)
  end
end
