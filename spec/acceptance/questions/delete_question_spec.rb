require_relative '../acceptance_helper'

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
      expect(page).to have_content question.title

      click_on 'Delete Question'
      expect(page).to have_content 'Question was successfully destroyed.'
      expect(page).to_not have_content question.title
    end

    scenario 'Authenticated user can not delete no own question' do
      sign_in(user)

      visit question_path(other_question)
      expect(page).to have_content other_question.title
      expect(page).to_not have_link 'Delete Question'
      expect(current_path).to eq question_path(other_question)
    end

    scenario 'Non-authenticated user tries delete question' do
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to_not have_link 'Delete Question'
    end
end
