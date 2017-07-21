require_relative '../acceptance_helper'

feature 'Sign in or sign up with twitter account' do
  background { OmniAuth.config.test_mode = true }

  given!(:user) { create(:user) }

  scenario 'existed user try to sign in' do
    OmniAuth.config.add_mock(:twitter, uid: '123456', info: { email: user.email })
    visit new_user_session_path
    click_on 'Sign in with Twitter'
    expect(page).to have_content 'Successfully authenticated from twitter account.'
  end

  scenario 'new user try sign in' do
    OmniAuth.config.add_mock(:twitter, uid: '123456', info: { email: 'new_user@mail.com' })
    visit new_user_session_path
    click_on 'Sign in with Twitter'
    expect(page).to have_content 'Successfully authenticated from twitter account.'
  end
end
