require_relative '../features_helper'

feature 'Signing in with Facebook' do
  let(:user) { create(:user) }

  describe 'Registered user tries to sign in' do
    before(:each) { OmniAuth.config.mock_auth[:facebook] = nil }
    scenario 'Registered user tries to sign in' do
      visit new_user_session_path
      OmniAuth.config.add_mock(:facebook, {info: { email: user.email }})
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(current_path).to eq root_path
    end

    scenario 'Non-registered user tries to sign in' do
      visit new_user_session_path
      OmniAuth.config.add_mock(:facebook, {info: { email: 'new@user.com' }})
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(current_path).to eq root_path
    end

    scenario 'Logged in user tries to log out' do
      visit new_user_session_path
      OmniAuth.config.add_mock(:facebook, {info: { email: user.email }})
      click_on 'Sign in with Facebook'
      click_on 'Sign out'

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq root_path
    end
  end
end