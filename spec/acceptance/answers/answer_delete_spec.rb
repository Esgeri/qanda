require 'rails_helper'

feature 'User can delete own answer', %q{
  In order to be able delete answer
  As an authenticated user and author of answer
  I want to be able to delete question
} do

    given(:user) { create(:user) }
    given(:question) { create(:question, :question_answers, user: user) }
    given(:another_question) { create(:question, :question_answers) }

    scenario 'Authenticated user can delete own answer' do
      sign_in(user)

      visit question_path(question)

      question.answers.each do |answer|
        expect(page).to have_content answer.body
        if answer.user_id == user.id
          click_on 'Delete Answer'
          expect(page).to have_content 'Your answer successfully deleted.'
        end
      end
      expect(current_path).to eq question_path(question)
    end

    scenario 'Authenticated user can not delete another answer' do
      sign_in(user)

      visit question_path(another_question)

      another_question.answers.each do |answer|
        expect(page).to have_content answer.body
        if answer.user_id != user.id
          expect(page).to_not have_link 'Delete Answer'
        end
      end
      expect(current_path).to eq question_path(another_question)
    end

    scenario 'Non-authenticated user tries delete answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete Answer'
    end
end
