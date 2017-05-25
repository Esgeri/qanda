require_relative '../acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I'd like to be able to edit my question
} do

    given(:user) { create(:user) }
    given(:another_user) { create(:user) }
    given(:no_author_question) { create(:question) }
    given!(:question) { create(:question, user: user) }
    given!(:another_question) { create(:question, user: another_user) }

    describe 'Unauthenticed user' do
      scenario 'try to edit question' do
        visit question_path(no_author_question)

        expect(page).to_not have_link 'Edit Question'
      end
    end

    describe 'No author' do
      scenario "try to edit other user's question", js: true do
        sign_in(user)
        visit question_path(another_question)
        expect(page).to_not have_link 'Edit Question'
      end
    end

    describe 'Authenticated user' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'sees link to Edit' do
        expect(page).to have_link 'Edit Question'
      end

      scenario 'try to edit his question with valid attributes', js: true do
        click_on 'Edit Question'
        within '.edit-question' do
          fill_in 'Question Title', with: 'edited question title'
          fill_in 'Question Body', with: 'edited question body'
          click_on 'Edit Question'
        end

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'text_field'
        expect(page).to_not have_selector 'text_area'
      end

      scenario 'try edit question with invalid data attributes', js: true do
        click_on 'Edit Question'
        within '.edit-question' do
          fill_in 'Question Title', with: ""
          fill_in 'Question Body', with: 'edited question body'
          click_on 'Edit Question'
        end

        expect(page).to have_content "Title can't be blank"
      end
    end
end
