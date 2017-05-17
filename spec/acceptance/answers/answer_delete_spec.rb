require 'rails_helper'

feature 'User can delete own answer', %q{
  In order to be able delete answer
  As an authenticated user and author of answer
  I want to be able to delete question
} do

    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given(:answer) { create(:answer, question: question, user: user) }
    given(:another_user) { create(:user) }

    scenario 'Authenticated user can delete own answer' do
      sign_in(user)

      visit question_path(answer.question)

      expect(page).to have_content answer.body
      click_on 'Delete Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Your answer successfully deleted.'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to_not have_content answer.body
    end

    scenario 'Authenticated user can not delete another answer' do
      sign_in(another_user)

      visit question_path(question)

      expect(page).to_not have_link 'Delete Answer'

      expect(current_path).to eq question_path(question)
    end

    scenario 'Non-authenticated user tries delete answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete Answer'
    end
end
