require_relative 'features_helper'

feature 'Sign up' do
  scenario 'User can sign up with email and password' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'

    expect(page).to have_content 'You have signed up successfully'
  end
  given(:user) { create(:user) }
  scenario 'Registered user tries to sign up' do
    sign_up_user(user)

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq '/users'
  end

  scenario 'User can not sign up without email or password' do
    visit new_user_registration_path
    click_button 'Sign up'

    expect(page).to have_content "can't be blank"
  end
end