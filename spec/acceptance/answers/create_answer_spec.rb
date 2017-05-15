require 'rails_helper'

feature 'Create answer', %q{
  In order to be able answer
  As an authenticated user
  I want to be able to create answer for question
} do

    given(:user) { create(:user) }
    given(:question) { create(:question) }

    scenario 'Authenticated user can create answer' do
      sign_in(user)

      visit question_path(question)
      fill_in 'Your Answer', with: 'Ask Google!'
      click_on 'Post Your Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Ask Google!'
      expect(current_path).to eq question_path(question)
    end

    scenario 'Non-authenticated user can tries to create answer' do
      visit question_path(question)

      expect(page).to_not have_selector '.btn btn-primary'
    end

    scenario 'Authenticated user can not create answer with invalid body' do
      sign_in(user)

      visit question_path(question)
      fill_in 'Your Answer', with: ''
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank."
    end
end
