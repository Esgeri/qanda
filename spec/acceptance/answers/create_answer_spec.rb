require_relative '../acceptance_helper'

feature 'Create answer', %q{
  In order to be able answer
  As an authenticated user
  I want to be able to create answer for question
} do

    given(:user) { create(:user) }
    given!(:question) { create(:question) }

    scenario 'Authenticated user can create answer', js: true do
      sign_in(user)

      visit question_path(question)
      fill_in 'Your Answer', with: 'Ask Google!'
      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_content 'Ask Google!'
      end
    end

    scenario 'Non-authenticated user can tries to create answer' do
      visit question_path(question)

      expect(page).to_not have_selector '.btn btn-primary'
    end

    scenario 'Authenticated user can not create answer with invalid body', js: true do
      sign_in(user)

      visit question_path(question)
      fill_in 'Your Answer', with: ''
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end

    context 'multiple sessions' do
      scenario "answers appears on another user's page", js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('quest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          click_on 'Ask Question'
          fill_in 'Title', with: 'Test question'
          fill_in 'Body', with: 'text text'
          click_on 'Create'

          expect(page).to have_content 'Test question'
        end

        Capybara.using_session('quest') do
          expect(page).to have_content 'Test question'
        end
      end
    end
end
