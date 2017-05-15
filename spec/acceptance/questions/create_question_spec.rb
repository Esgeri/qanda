require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

    given(:user) { create(:user) }

    scenario 'Authenticated user creates question' do
      sign_in(user)

      visit questions_path
      click_on 'Ask Question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text'
      click_on 'Create'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text'
    end

    scenario 'Non-authenticated user can tries to create question' do
      visit questions_path
      click_on 'Ask Question'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(current_path).to eq new_user_session_path
    end

    scenario 'Authenticated user can not create question with invalid title' do
      sign_in(user)

      visit questions_path
      click_on 'Ask Question'

      fill_in 'Title', with: ''
      fill_in 'Body', with: 'text text'
      click_on 'Create'

      expect(page).to have_content "Title can't be blank"
    end
end
