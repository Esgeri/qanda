class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :define_oauth_from

  def facebook; end

  def twitter; end

  private

  def define_oauth_from
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: request.env['omniauth.auth'] ['provider']) if is_navigational_format?
    end
  end
end
