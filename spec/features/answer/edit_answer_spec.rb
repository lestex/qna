require_relative '../features_helper'

feature 'Edit answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  before { create(:answer, question: question, user: question.user) }

  context 'Authenticated user' do
    scenario 'can edit his answer', js: true do
      log_in_user(question.user)
      visit question_path(question)
      within '.answers' do
        click_on 'Edit answer'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content question.answers.first.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "cannot edit an answer he doesn't own" do
      log_in_user(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit answer'
      end
    end
  end

  scenario 'Uauthenticated user tries to edit an answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end
end