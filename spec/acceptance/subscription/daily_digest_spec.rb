require_relative '../acceptance_helper'

RSpec.feature 'Subscribe question', %q{
  In order to be able to inform by mail
  As an authenticated user
  I want to be able to inform about new questions for last day
} do

  given(:users) { create_pair(:user) }
  given!(:new_question) { create(:question, user: users[0]) }
  given!(:old_question) { create(:question, created_at: (Time.zone.now - 1.day), user: users[1]) }

  scenario 'every day daily digest sending to all registered users', js: true do
    Sidekiq::Testing.inline! do
      DailyDigestJob.perform_now

      users.each do |user|
        open_email(user.email)
        expect(current_email).to have_link new_question.title
        expect(current_email).to_not have_link old_question.title
      end

      clear_emails
    end
  end
end
