require 'rails_helper'

feature 'User sign out', %q{
  In order to become a Guest
  User needs to be able to sign out
} do
  given(:user) { create(:user) }

  scenario 'Logged in user tries to sign out' do
    log_in_user(user)

    sign_out_user
  end

  scenario 'Not logged in user tries to sign out' do
    sign_out_user
  end
end