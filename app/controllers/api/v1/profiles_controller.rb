class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :read_self, :profile
    respond_with current_resource_owner
  end

  def index
    authorize! :read_all, :profile
    respond_with User.all_except(current_resource_owner)
  end
end