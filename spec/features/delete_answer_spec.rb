require_relative 'features_helper'

feature 'Delete answer' do

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: user) }

  context 'authenticated user' do
    scenario 'deletes answer he owns', js: true do
      log_in_user(answer.user)
      visit question_path(question)  
      click_on 'Delete answer'

      expect(page).to have_current_path(question_path(question))
      expect(page).to have_content 'Answer has been deleted'
      expect(page).not_to have_content answer.body
    end

    scenario "deletes answer he does't own" do
      log_in_user(user)
      visit question_path(question)

      expect(page).to_not have_content 'Remove answer'
    end
  end

  context 'unauthenticated user tries to delete his answer' do
    scenario 'link delete is not present' do
      visit question_path(question)
    
      expect(page).to_not have_link 'Delete answer'
    end
  end
end