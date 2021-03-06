require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js do
        flash.now[:error] = exception.message
        render 'denied',  status: :forbidden
      end
      format.json { render json: { errors: [exception.message] }, status: :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end

  check_authorization unless: :devise_controller?
  def current_user
    return @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    @current_user ||= warden.authenticate(scope: :user)
  end
end
