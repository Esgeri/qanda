require 'rails_helper'

feature 'User can delete own question', %q{
  In order to be able delete question
  As an authenticated user and author of question
  I want to be able to delete question
} do

    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given(:other_question) { create(:question) }

    scenario 'Authenticated user can delete own question' do
      sign_in(user)

      visit question_path(question)

      click_on 'Delete Question'

      expect(page).to have_content 'Your question successfully deleted.'
      expect(page).to_not have_content question.title
    end

    scenario 'Authenticated user can not delete no own question' do
      sign_in(user)

      visit question_path(other_question)
      expect(page).to_not have_link 'Delete Question'
    end

    scenario 'Non-authenticated user tries delete question' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete Question'
    end
end
