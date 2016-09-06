require_relative 'features_helper'

feature 'delete an answer' do

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  context 'authenticated user deletes answer' do
    scenario 'he owns' do
      log_in_user(answer.user)
      visit question_path(question)    
      click_on 'Delete answer'

      expect(page).to have_current_path(question_path(question))
      expect(page).to have_content 'Answer has been deleted'
      expect(page).not_to have_content answer.body
    end

    scenario 'authenticated user deletes his answer' do
      log_in_user(answer.user)
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_current_path(question_path(question))
      expect(page).to have_content 'Answer has been deleted'
      expect(page).not_to have_content answer.body
    end
  end

  context 'unauthenticated user tries to delete his answer' do
    scenario 'link delete is not present' do
      visit question_path(question)
    
      expect(page).to_not have_link('Delete answer')
    end
  end
end