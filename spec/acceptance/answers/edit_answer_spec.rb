require_relative '../acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I'd like to be able to edit my answer
} do

    given(:user) { create(:user) }
    given(:another_user) { create(:user) }
    given(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question, user: user) }
    given!(:another_answer) { create(:answer, question: question, user: another_user) }

    scenario 'Unauthenticed user try to edit answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit Answer'
    end

    describe 'Authenticated user' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'sees link to Edit' do
        within '.answers' do
          expect(page).to have_link 'Edit Answer'
        end
      end

      scenario 'try to edit his answer', js: true do
        click_on 'Edit Answer'
        within '.answers' do
          fill_in 'Your Answer', with: 'edited answer'
          click_on 'Post Your Answer'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'try edit answer with invalid data', js: true do
        click_on 'Edit Answer'

        within '.answers' do
          fill_in 'Your Answer', with: ''
          click_on 'Post Your Answer'
          expect(page).to have_content answer.body
          expect(page).to have_selector 'textarea'
        end
        expect(page).to have_content "Body can't be blank"
      end

      scenario "try to edit other user's answer", js: true do
        within ".answer-#{answer.id}" do
          expect(page).to have_content answer.body
          expect(page).to have_link 'Edit Answer'
        end

        within ".answer-#{another_answer.id}" do
          expect(page).to have_content another_answer.body
          expect(page).to_not have_link 'Edit Answer'
        end
      end
    end
end
