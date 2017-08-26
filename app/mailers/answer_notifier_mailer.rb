class AnswerNotifierMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_notifier_mailer.notify.subject
  #
  def notify(user, answer)
    @answer = answer
    @greeting = "Hi #{user.email}"
    mail(to: user.email, subject: "There is a new answer to the question: #{@answer.question.title}")
  end
end
