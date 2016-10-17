require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "POST #set_email" do
    it "creates a user from params" do
      session['omniauth.user_hash'] = {
              'provider' => 'facebook', 'uid' => 123456,
              'user_password' => '123456'
              }
      expect { post :set_email, params: { user: { email: 'test@example.com' } }}.to change(User, :count).by(1)
    end
  end

end
