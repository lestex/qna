require 'rails_helper'

feature 'User sign up', %q{
  In order to become a User
  As a User
  Guest needs to be able to sign in
} do
  given(:user) { create(:user) }

  scenario 'Registered user tries to sign up' do
    sign_up_user(user)

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq '/users'
  end
  
  scenario 'Unregistered user tries to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully'
    expect(current_path).to eq root_path
  end
end