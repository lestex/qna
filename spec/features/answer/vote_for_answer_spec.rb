require_relative '../features_helper.rb'

feature 'Vote for answer' do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  scenario 'Unauthenticated user cannot vote', js: true  do
    visit question_path(answer.question)

    within '.answers' do
      expect(page).to_not have_selector(:link_or_button, 'Vote+')
      expect(page).to_not have_selector(:link_or_button, 'Vote-')
      expect(page).to_not have_selector(:link_or_button, 'Reject Vote')
    end
  end

  context 'Authenticated user' do
    scenario 'cannot vote for answer hi owns', js: true do
      log_in_user(answer.user)
      visit question_path(answer.question)

      within '.answers' do
        expect(page).to_not have_selector(:link_or_button, 'Vote+')
        expect(page).to_not have_selector(:link_or_button, 'Vote-')
        expect(page).to_not have_selector(:link_or_button, 'Reject Vote')
      end
    end
  

    scenario 'votes for an answer', js: true do
      log_in_user(user)
      visit question_path(answer.question)

      within '.answers' do
        expect(page).to_not have_selector(:link_or_button, 'Reject Vote')
        click_on 'Vote+'
        within ".vote-rating-answer-#{answer.id}" do
          expect(page).to have_content '+1'
        end
        expect(page).to_not have_selector(:link_or_button, 'Vote+')
        expect(page).to_not have_selector(:link_or_button, 'Vote-')
        expect(page).to have_selector(:link_or_button, 'Reject Vote')
      end
    end
  
    scenario 'cancels previous vote and re-votes for another answer', js: true do
      log_in_user(user)
      visit question_path(answer.question)

      within '.answers' do
        click_on 'Vote+'
        click_on 'Cancel Vote'
        click_on 'Vote-'
        within ".vote-rating-answer-#{answer.id}" do
          expect(page).to have_content '-1'
        end
      end
    end
  
    scenario 'votes for a question and answer at the same time', js: true do
      log_in_user(user)
      visit question_path(answer.question)

      within '.question' do
        click_on 'Vote+'
      end

      within '.answers' do
        click_on 'Vote+'
        within ".vote-rating-answer-#{answer.id}" do
          expect(page).to have_content '+1'
        end
      end
    end
  end
end