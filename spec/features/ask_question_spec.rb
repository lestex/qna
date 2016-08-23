require 'rails_helper'

feature 'User can ask question' do
  given(:user) {create(:user)}
  context 'when signed in' do
    scenario 'User can ask a question' do
      visit root_path
      log_in_user(user)
      click_link 'Ask question'
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'

      click_button 'Create question'
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Question body'
    end
  end

  context 'when not signed in' do
    scenario 'User redirected to a login form' do
      visit root_path
      click_link 'Ask question'

      expect(page).to have_content 'You need to sign in'
    end
  end
  
end