class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #
  def digest(user)
    @questions = Question.created_yesterday

    if @questions.any?
      mail(to: user.email, subject: 'Daily digest of questions')
    end
  end
end
