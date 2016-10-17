require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #set_email" do
    it "returns http success" do
      get :set_email
      expect(response).to have_http_status(:success)
    end
  end

end
