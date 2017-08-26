# Preview all emails at http://localhost:3000/rails/mailers/answer_notifier
class AnswerNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/answer_notifier/notify
  def notify
    AnswerNotifierMailer.notify
  end

end
