require_relative '../acceptance_helper'

feature 'Mark best answer', %q{
  In order to mark best answer for own question
  As an author of question
  I'd like to be able to choice best answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:second_answer) { create(:answer, best: false, question: question, user: user) }
  given!(:best_answer) { create(:answer, best: true, question: question, user: user) }
  given!(:another_user) { create(:user) }
  given!(:another_question) { create(:question, user: another_user) }
  given!(:another_answer) { create(:answer, question: another_question, user: another_user) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario 'see checkbox for mark' do
      visit question_path(question)

      within ".answer-#{answer.id}" do
        expect(page).to have_link 'Mark as best answer'
      end
    end

    scenario "author try to mark the best answer for question", js: true do
      visit question_path(question)

      click_on 'Mark as best answer', match: :first

      expect(page).to have_content 'Best answer!'
    end

    scenario "best answer should be only one", js: true do
      visit question_path(question)

      within ".answer-#{best_answer.id}" do
        expect(page).to have_content best_answer.body
      end
    end

    scenario "no author doesn't see the checkbox" do
      visit question_path(another_question)

      within ".answer-#{another_answer.id}" do
        expect(page).to_not have_link 'Mark as best answer'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not mark best answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Mark as best answer'
    end
  end
end
