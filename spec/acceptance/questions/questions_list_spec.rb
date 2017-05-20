require_relative '../acceptance_helper'

feature 'User can view list of questions', %q{
  In order to view list of questions
  As an user
  I want to be able view questions list
} do

    given!(:questions) { create_list(:question, 2) }

    scenario 'User view questions list' do
      visit questions_path

      questions.each do |question|
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end
    end

end
