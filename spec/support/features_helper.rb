module FeaturesHelper
  def log_in_user(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  def sign_up_user(user)
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_button 'Sign up'
  end

  def create_answer(question)
    visit question_path(question)
    fill_in 'Body', with: 'The new answer'
    click_button 'Answer a question'
  end
end
