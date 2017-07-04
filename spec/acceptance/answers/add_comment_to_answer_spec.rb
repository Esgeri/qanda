require_relative '../acceptance_helper'

feature 'Add comment to an answer', %q{
  In order to understand answer
  as registred user
  I'd like to be able to comment an answer
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Author comments his own answer', js: true do
    sign_in(author)
    visit question_path(question)

    within '.answers' do
      find('.add-comment-link').trigger('click')
    end

    within '.answers .new-comment' do
      fill_in 'Your Comment', with: 'New Comment'
      click_on 'Save Comment'

      expect(page).to have_no_selector 'textarea'
    end

    within '.answers .comments' do
      expect(page).to have_content 'New Comment'
    end
  end

  scenario 'User comments an answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      find('.add-comment-link').trigger('click')
    end

    within '.answers .new-comment' do
      fill_in 'Your Comment', with: 'New Comment'
      click_on 'Save Comment'

      expect(page).to have_no_selector 'textarea'
    end

    within '.answers .comments' do
      expect(page).to have_content 'New Comment'
    end
  end

  scenario 'Guest comments an answer', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to have_no_link 'Add Comment'
    end
  end

  context 'multiple sessions', js: true do
    scenario "answer's comments appear on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          find('.add-comment-link').trigger('click')
        end

        within '.answers .new-comment' do
          fill_in 'Your Comment', with: 'New Comment'
          click_on 'Save Comment'

          expect(page).to have_no_selector 'textarea'
        end

        within '.answers .comments' do
          expect(page).to have_content 'New Comment'
        end
      end

      Capybara.using_session('guest') do
        within '.answers .comments' do
          expect(page).to have_content 'New Comment'
        end
      end
    end
  end
end
