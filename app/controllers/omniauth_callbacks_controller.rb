class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :define_oauth_from, except: :confirm_email

  def facebook; end

  def twitter(auth = nil)
    unless @user.persisted?
      session['devise.twitter_data'] = request.env['omniauth.auth'].except('extra')
      render 'devise/confirmations/confirm_email'
    end
  end

  def confirm_email
    session_key = 'devise.twitter_data'
    auth = OmniAuth::AuthHash.new(session[session_key])
    session.delete(session_key)
    auth[:info][:email] = params[:email]
    auth[:confirmation] = true
    define_oauth_from(auth)
  end

  private

  def define_oauth_from(auth = nil)
    auth ||= request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: request.env['omniauth.auth'] ['provider']) if is_navigational_format?
    end
  end
end
