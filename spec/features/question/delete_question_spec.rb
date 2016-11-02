require_relative '../features_helper'

feature 'delete a question' do
  let(:user) { create(:user_with_question) }
  let(:question) { create(:question) }

  context 'authenticated user' do
    scenario 'deletes a question he asked' do
      log_in_user(user)
      visit question_path(user.questions.last)
      click_on 'Delete question'

      expect(page).not_to have_current_path(question_path(user.questions.last))    
      expect(page).to have_content 'deleted successfully'
      expect(page).not_to have_content user.questions.last
    end

    scenario "deletes a question he didn't asked" do
      log_in_user(user)
      visit question_path(question)

      expect(page).to_not have_content 'delete question' 
    end
  end

  context 'unauthenticated user' do
    scenario 'cannot see link to delete question' do
      visit question_path(user.questions.last)
      
      expect(page).not_to have_link('Delete answer',
        href: question_path(question, method: :delete))
    end
  end
end