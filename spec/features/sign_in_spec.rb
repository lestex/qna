require 'rails_helper'

feature 'User sign in', %q{
  In order to ask question
  As a User
  Guest needs to be able to sign in
} do
  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    log_in_user(user)

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Unregistered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end
end