require 'rails_helper'

feature 'User can answer a question' do
  given(:user) {create(:user)}
  given(:question) {create(:question)}

  context 'when signed in' do
    scenario 'User can answer a question' do
      log_in_user(user)
      create_answer(question)

      expect(page).to have_content 'The new answer'
    end  
  end

  context 'when not signed in' do
    scenario 'User redirected to a login form' do
      create_answer(question)
      
      expect(page).to have_content 'You need to sign'
    end
  end
end