class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    define_oauth_from(:facebook)
  end

  def twitter
    define_oauth_from(:twitter)
  end

  private

  def define_oauth_from(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.to_s) if is_navigational_format?
    end
  end
end
