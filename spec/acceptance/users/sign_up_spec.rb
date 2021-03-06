require_relative '../acceptance_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign up
} do

    scenario 'Non-registered user try to sign up' do
      visit root_path
      click_on 'Sign up'

      fill_in 'Email', with: 'user@test.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_button 'Sign up'

      open_email('user@test.com')
      expect(current_email).to have_content 'You can confirm your account email through the link below:'
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    given(:user) { create(:user) }

    scenario 'Registered user try to sign up' do
      visit root_path
      click_on 'Sign up'

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_button 'Sign up'

      expect(page).to have_content 'error prohibited this user from being saved'
    end
end
