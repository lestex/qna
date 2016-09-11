require_relative '../features_helper'

feature 'Sign out' do
  given(:user) { create(:user) }
  context 'when signed in' do
    scenario 'user can sign out' do
      log_in_user(user)

      visit root_path
      click_link 'Sign out'

      expect(page).not_to have_text 'Signed in as'
      expect(page).not_to have_link 'Sign out'
    end
  end

  context 'when not signed in' do
    scenario 'user can not sign out' do
      visit root_path

      expect(page).not_to have_link 'Sign out'
    end
  end
end