require_relative '../features_helper'

feature 'Editing question' do

  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'Authenticated user' do
    before { log_in_user(user) }

    scenario 'can see link to edit his question' do
      question.update(user: user)
      visit question_path(question)

      within '.question' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'cannot see link to edit not his question' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'tries to edit his question', js: true do
      question.update(user: user)
      visit question_path(question)
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textfield'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario "cannot see link edit" do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end