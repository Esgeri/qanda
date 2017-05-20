require_relative '../acceptance_helper'

feature 'User sign out', %q{
  In order to sign out session
  As an authenticated user
  I want to be able to sign out
} do

    given(:user) { create(:user) }

    scenario 'Authenticated user try to sign out' do
      sign_in(user)

      click_on 'Sign out'

      expect(page).to have_content 'Signed out successfully.'
    end

end
