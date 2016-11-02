require_relative '../features_helper'

feature 'Add comment to question' do
  let(:question) { create(:question) }

  context 'Authenticated user' do
    before do
      log_in_user(question.user)
      visit question_path(question)
    end
    scenario 'adds comment to a question', js: true do
      within '.question-comments' do
        click_on 'Add comment'
        fill_in 'Comment text', with: 'A new Comment'
        click_on 'Save'
        expect(page).to have_content 'A new Comment'
      end
    end

    scenario 'adds an empty comment', js: true do
      within '.question-comments' do
        click_on 'Add comment'
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Non-authenticated user cannot comment on a question', js: true do
    visit question_path(question)
    within '.question-comments' do
      expect(page).to_not have_content 'Add comment'
    end
  end
end
