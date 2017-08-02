require_relative '../acceptance_helper'

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

      expect(page).to have_content 'Question was successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text'
    end

    context 'multiple sessions' do
      scenario "questions appears on another user's page", js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit questions_path
        end

        Capybara.using_session('quest') do
          visit questions_path
        end

        Capybara.using_session('user') do
          click_on 'Ask Question'
          fill_in 'Title', with: 'Test question'
          fill_in 'Body', with: 'text text'
          click_on 'Create'

          expect(page).to have_content 'Question was successfully created.'
          expect(page).to have_content 'Test question'
          expect(page).to have_content 'text text'
        end

        Capybara.using_session('quest') do
          expect(page).to have_content 'Test question'
        end
      end
    end

    scenario 'Non-authenticated user can tries to create question' do
      visit questions_path
      expect(page).to have_no_link 'Ask Question'
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
