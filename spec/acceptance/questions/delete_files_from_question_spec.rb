require_relative '../acceptance_helper'

RSpec.feature 'Delete files of question', %q{
  In order to delete the downloaded file
  As the author of the question
  I want to be able to delete attached file
} do

    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given!(:attachment) { create(:attachment, attachable: question) }
    given(:another_user) { create(:user) }
    given(:another_question) { create(:question, user: another_user) }
    given!(:another_attachment) { create(:attachment, attachable: another_question) }

    describe 'Authenticated user' do
      before { sign_in(user) }

      context 'Author' do
        scenario 'can delete attached file', js: true do
          visit question_path(question)
          attachment

          within '.attachment_list' do
            click_on 'Delete file'
            expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
          end
         end
       end

       context 'No author' do
        scenario 'can not delete attached file', js: true do
          visit question_path(another_question)
          another_attachment
          expect(page).to_not have_link 'Delete file'
         end
       end
     end

      scenario 'Non-authenticated user can not delete file', js: true do
        visit question_path(question)
        attachment
        expect(page).to_not have_link 'Delete file'
     end
end
