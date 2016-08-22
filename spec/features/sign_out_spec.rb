require 'rails_helper'

feature 'User sign out', %q{
  In order to become a Guest
  User needs to be able to sign out
} do
  scenario 'Logged in user tries to sign out' do
    User.create!(email: 'user@test.com', password: '123456')
    
    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    page.driver.delete destroy_user_session_path
    expect(page).to have_content 'You are being redirected'
    expect(current_path).to eq destroy_user_session_path
  end

  scenario 'Not logged in user tries to sign out' do
    page.driver.delete destroy_user_session_path

    expect(page).to have_content 'You are being redirected'
    expect(current_path).to eq destroy_user_session_path
  end
end