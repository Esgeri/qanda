require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

    given(:user) { create(:user) }
    given(:question) { create(:question) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User adds file when asks question', js: true do
      fill_in 'Your Answer', with: 'My answer'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end

    scenario 'User adds several files', js: true do
      fill_in 'Your Answer', with: 'My answer'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

      click_on 'Show attachment form'
      within page.all('.nested-fields').last do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end
      click_on 'Post Your Answer'

      expect(page).to have_content 'Attachments'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
end
