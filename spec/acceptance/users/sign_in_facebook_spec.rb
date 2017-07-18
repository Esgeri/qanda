require_relative '../acceptance_helper'

feature 'Sign in or sign up with facebook account' do
  background { OmniAuth.config.test_mode = true }

  given!(:user) { create(:user) }

  scenario 'existed user try to sign in' do
    OmniAuth.config.add_mock(:facebook, uid: '123456', info: { email: user.email })
    visit new_user_session_path
    click_on 'Sign in with Facebook'
    expect(page).to have_content 'Successfully authenticated from facebook account.'
  end

  scenario 'new user try sign in' do
    OmniAuth.config.add_mock(:facebook, uid: '123456', info: { email: 'new_user@mail.com' })
    visit new_user_session_path
    click_on 'Sign in with Facebook'
    expect(page).to have_content 'Successfully authenticated from facebook account.'
  end
end
