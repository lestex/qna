class UsersController < DeviseController
  def set_email
    auth = session['omniauth.user_hash']
    @user = User.build_with_email(params, auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Successfully authenticated from #{auth["provider"].capitalize} account."
      #set_flash_message(:notice, :success, kind: auth['provider'].capitalize) if is_navigational_format?
    else
      redirect_to :new_user_registration
    end
  end
end
