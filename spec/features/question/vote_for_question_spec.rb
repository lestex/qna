require_relative '../features_helper'

feature 'Vote for question' do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  scenario 'Unauthenticated user cannot vote', js: true  do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Vote+')
    expect(page).to_not have_selector(:link_or_button, 'Vote-')
    expect(page).to_not have_selector(:link_or_button, 'Cancel Vote')
  end

  context 'Authenticated user' do
    scenario 'cannot vote for question hi owns', js: true do
      log_in_user(question.user)
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Vote+')
      expect(page).to_not have_selector(:link_or_button, 'Vote-')
      expect(page).to_not have_selector(:link_or_button, 'Cancel Vote')
    end

    scenario 'votes for a question', js: true do
      log_in_user(user)
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Cancel Vote')
      click_on 'Vote+'
      within '.vote-rating-question' do
        expect(page).to have_content '+1'
      end
      expect(page).to_not have_selector(:link_or_button, 'Vote+')
      expect(page).to_not have_selector(:link_or_button, 'Vote-')
      expect(page).to have_selector(:link_or_button, 'Cancel Vote')
    end

    scenario 'cancels vote and votes for another question', js: true do
      log_in_user(user)
      visit question_path(question)

      click_on 'Vote+'
      click_on 'Cancel Vote'
      click_on 'Vote-'
      within '.vote-rating-question' do
        expect(page).to have_content '-1'
      end
    end
  end
end