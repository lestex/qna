module FeaturesHelper
  def log_in_user(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def sign_up_user(user)
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'
  end

  def sign_out_user
    page.driver.delete destroy_user_session_path
    expect(page).to have_content 'You are being redirected'
    expect(current_path).to eq destroy_user_session_path
  end
end
