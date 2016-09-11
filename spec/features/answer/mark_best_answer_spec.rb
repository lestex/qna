require_relative '../features_helper'

feature 'Mark best answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  before { create_list(:answer, 3, question: question, user: question.user) }

  context 'Authenticated user' do
    scenario 'author marks one answer as best', js: true do
      log_in_user(question.user)
      visit question_path(question)
      within '.answers' do
        click_on 'Mark as best', match: :first

        expect(page).to have_selector('.best-answer', count: 1)
        expect(page).to have_link('Mark as best', count: 2)
      end
    end

    scenario 'author can mark only one answer as best', js: true do
      log_in_user(question.user)
      visit question_path(question)
      within '.answer-1' do
        click_on 'Mark as best'
      end
      expect(page).to have_selector('.best-answer')
      within '.answer-2' do
        click_on 'Mark as best'
      end
      expect(page).not_to have_selector('.answer-2.best-answer')
      expect(page).to have_selector('.best-answer', count: 1)
      expect(page).to have_link('Mark as best', count: 2)
    end

    scenario 'best answer always first in the list', js: true do
      log_in_user(question.user)
      visit question_path(question)
      within '.answer-3' do
        click_on 'Mark as best'
      end
      sleep 1
      within('.answers') do
        expect(page).to have_css('.best-answer', count: 1)
        expect(page).to have_css('.answer-3.best-answer')
        expect(page.first(:css, 'div')[:class].include?('best-answer')).to eq true
      end
    end

    scenario "not author cannot mark an answer as best" do
      log_in_user(user)
      visit question_path(question)
      expect(page).to_not have_link 'Mark as best'
    end
  end

  context 'Unathenticated user' do 
    scenario 'cannot mark an answer as best' do
      visit question_path(question)
      expect(page).to_not have_link 'Mark as best'
    end
  end
end