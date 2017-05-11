require 'rails_helper'

feature 'User can view questions with answers', %q{
  In order to be able view answers for question
  As an user
  I want to be able to view answers for question
} do

    given(:question) { create(:question, :question_answers) }

    scenario 'question with answers' do
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to have_content question.body

      question.answers.each do |answer|
        expect(page).to have_content answer.body
      end
    end

end
