require_relative '../features_helper'

feature 'Ask a question' do
  given(:user) {create(:user)}
  context 'authenticated user' do
    scenario 'asks a valid question' do      
      log_in_user(user)

      visit questions_path
      click_link 'Ask question'
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'
      click_button 'Create question'

      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Question body'
    end

    scenario 'asks an invalid question' do      
      log_in_user(user)

      visit questions_path
      click_link 'Ask question'
      fill_in 'Title', with: 'Question title'
      click_button 'Create question'
      
      expect(page).to have_content "can't be blank"      
    end
  end

  context 'unauthenticated user' do
    scenario 'asks question' do
      visit root_path
      click_link 'Ask question'

      expect(page).to have_content 'You need to sign in'
      expect(page).to have_current_path new_user_session_path
    end
  end
  
end