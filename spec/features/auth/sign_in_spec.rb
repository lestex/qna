require_relative '../features_helper'

feature 'Sign in' do
  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    log_in_user(user)

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Unregistered user tries to sign in' do
    visit root_path
    click_link 'Sign in'
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '123456'
    click_button 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end
end