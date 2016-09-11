require_relative '../features_helper'

feature 'Answer a question' do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}

  context 'authenticated user' do
    before {log_in_user(user)}

    scenario 'creates a valid answer to a question', js: true do       
      visit question_path(question)
      fill_in 'answer_body', with: 'The new answer'    
      click_button 'Answer a question'

      expect(page).to have_current_path(question_path(question))
      within '.answers' do 
        expect(page).to have_content 'The new answer'
      end
    end

    scenario 'creates an invalid answer to a question', js: true do
      visit question_path(question)

      click_button 'Answer a question'      
      expect(page).to have_content "can't be blank"
    end
  end

  context 'unauthenticated user' do
    scenario 'creates an answer to a question' do
      visit question_path(question)

      expect(page).not_to have_content 'Answer a question'
    end
  end
end