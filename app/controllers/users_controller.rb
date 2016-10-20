class UsersController < ApplicationController
  authorize_resource

  def set_email
    auth = session['devise.user_hash']
    @user = User.build_with_email(params, auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Successfully authenticated from #{auth["provider"].capitalize} account."      
    else
      redirect_to :new_user_registration
    end
  end
end
