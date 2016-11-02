require_relative '../features_helper'

feature 'Add comment to answer' do
  let(:answer) { create(:answer) }

  context 'Authenticated user' do
    before do
      log_in_user(answer.user)
      visit question_path(answer.question)
    end
    scenario 'comments an answer', js: true do
      within '.answer-comments' do
        click_on 'Add comment'
        fill_in 'Comment text', with: 'Some Comment'
        click_on 'Save'
        expect(page).to have_content 'Some Comment'
      end
    end

    scenario 'adds an empty comment', js: true do
      within '.answer-comments' do
        click_on 'Add comment'
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Non-authenticated user cannot comment on an answer', js: true do
    visit question_path(answer.question)
    within '.answer-comments' do
      expect(page).to_not have_content 'Add comment'
    end
  end
end