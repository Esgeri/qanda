require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

    given(:user) { create(:user) }

    before do
      sign_in(user)
      visit new_question_path
    end

    scenario 'User adds file when asks question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text text text'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end

    scenario 'User can adds several files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text text text'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

      click_on 'Show attachment form'
      within page.all('.nested-fields').last do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end
      click_on 'Create'

      expect(page).to have_content 'Attachments'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
end
