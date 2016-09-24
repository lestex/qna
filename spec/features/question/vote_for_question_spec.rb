require_relative '../features_helper.rb'

feature 'Vote for question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'authenticated user' do
    scenario 'votes for a question', js: true do
      log_in_user(user)
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Cancel vote')
      click_on 'Vote+'
      within '.vote-rating-question' do
        expect(page).to have_content('+1')
      end
      expect(page).to_not have_selector(:link_or_button, 'Vote+')
      expect(page).to_not have_selector(:link_or_button, 'Vote-')
      expect(page).to have_selector(:link_or_button, 'Cancel vote')
    end

    scenario 'cancels his vote and votes for another question', js: true do
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

  scenario 'cannot vote for the question hi owns', js: true do 
    log_in_user(question.user)
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Vote+')
    expect(page).to_not have_selector(:link_or_button, 'Vote-')
    expect(page).to_not have_selector(:link_or_button, 'Cancel vote')
  end
  
  scenario 'unauthenticated user cannot vote', js: true  do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Vote+')
    expect(page).to_not have_selector(:link_or_button, 'Vote-')
    expect(page).to_not have_selector(:link_or_button, 'Cancel Vote')
  end

 end