class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authenticate_with_provider

  def twitter    
  end

  def facebook
  end

  private
  def authenticate_with_provider
    auth_hash = request.env['omniauth.auth']
  	@user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth_hash.provider.capitalize) if is_navigational_format?
    end
  end
end