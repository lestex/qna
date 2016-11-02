require_relative '../features_helper'

feature 'Signing in with Twitter' do
  let(:user) { create(:user) }

  describe 'Registered user tries to sign in' do
    before(:each) { OmniAuth.config.mock_auth[:twitter] = nil }

    scenario 'Registered user tries to sign in' do      
      visit new_user_session_path
      OmniAuth.config.add_mock(:twitter)
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Please enter your email'
      fill_in 'Email', with: user.email
      click_on 'Continue'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(current_path).to eq root_path
    end

    scenario 'Non-registered user tries to sign in' do
      visit new_user_session_path
      OmniAuth.config.add_mock(:twitter)
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Please enter your email'
      fill_in 'Email', with: user.email
      click_on 'Continue'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(current_path).to eq root_path
    end

    scenario 'Authenticated user tries to log out' do
      visit new_user_session_path
      OmniAuth.config.add_mock(:twitter)
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Please enter your email'
      fill_in 'Email', with: user.email
      click_on 'Continue'

      click_on 'Sign out'

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq root_path
    end
  end
end