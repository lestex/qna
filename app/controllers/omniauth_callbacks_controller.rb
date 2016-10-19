class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authenticate_with_provider

  def twitter    
  end

  def facebook
  end

  private
  def authenticate_with_provider
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    elsif @user.email.blank?
      data_hash = { provider: auth.provider, uid: auth.uid.to_s }
      session['devise.user_hash'] = data_hash
      render 'users/set_email'
    end
  end
end