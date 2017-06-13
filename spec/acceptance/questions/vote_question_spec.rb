require_relative '../acceptance_helper'

RSpec.feature 'Vote question', %q{
  In order to be able to vote 'like/dislike/cancel vote'
  As an authenticated user
  I want to be able to vote question
} do

    given!(:user) { create(:user) }
    given!(:another_user) { create(:user) }
    given!(:question) { create(:question, user: user) }
    given!(:no_author_question) { create(:question, user: another_user) }
    given!(:another_question) { create(:question) }

    describe 'Authenticated user' do
      before { sign_in(user) }

      context 'Author of question' do
        scenario 'can not vote own question', js: true do
          visit question_path(question)
          expect(page).to_not have_css '.rating-links'
        end
      end

      context 'No author of question' do
        before { visit question_path(no_author_question) }

        scenario 'See links for vote', js: true do
          expect(page).to have_css '.rating-links'
        end

        scenario 'can vote like', js: true do
          find('.like').trigger('click')
          expect(page).to have_content 'Rating: 1'
        end

        scenario 'can vote dislike', js: true do
          find('.dislike').trigger('click')
          expect(page).to have_content 'Rating: -1'
        end

        scenario 'unvote', js: true do
          find('.like').trigger('click')
          expect(page).to have_content 'Rating: 1'

          find('.cancel_vote').trigger('click')
          expect(page).to have_content 'Rating: 0'

          find('.dislike').trigger('click')
          expect(page).to have_content 'Rating: -1'
        end
      end
    end

    scenario 'Non-authenticated user', js: true do
      visit question_path(another_question)
      expect(page).to_not have_css '.rating-links'
    end
end
