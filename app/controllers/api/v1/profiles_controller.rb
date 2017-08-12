class Api::V1::ProfilesController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:users, :me]

  authorize_resource :user

  def me
    respond_with current_resource_owner
  end

  def users
    respond_with User.all_users_but_me(current_resource_owner)
  end
end
