require_relative '../features_helper.rb'

feature 'Vote for question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Authenticated user' do
    scenario 'votes for a question', js: true do
      log_in_user(user)
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Decline vote')
      click_on 'Vote+'
      within '.question_votes' do
        expect(page).to have_content '+1'
      end
      expect(page).to_not have_selector(:link_or_button, 'Vote+')
      expect(page).to_not have_selector(:link_or_button, 'Vote-')
      expect(page).to have_selector(:link_or_button, 'Decline vote')
    end
    scenario 'cannot vote for the question hi owns', js: true do 
      log_in_user(question.user)
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Vote+')
      expect(page).to_not have_selector(:link_or_button, 'Vote-')
      expect(page).to_not have_selector(:link_or_button, 'Decline vote')
    end
  end
 end