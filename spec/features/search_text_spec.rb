require_relative 'features_helper'

feature 'Search for info' do
  let!(:question) { create(:question, title: 'find me question') }
  let!(:answer) { create(:answer, body: 'find me answer') }
  let!(:comment) { create(:comment, body: 'find me comment') }
  let!(:user) { create(:user, email: 'find@tutu.com') }

  scenario 'User can search question', js: true do
    visit root_path

    check 'Questions'
    fill_in 'Search text', with: question.title
    click_on 'Search'

    expect(page).to have_content question.title
  end

  scenario 'User can search answer', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      check 'Answers'
      fill_in 'Search text', with: answer.body
      click_on 'Search'

      expect(page).to have_content answer.body
    end
  end

  scenario 'User finds a comment by some text', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      check 'Comments'
      fill_in 'Search text', with: comment.body
      click_on 'Search'

      expect(page).to have_content comment.body
    end
  end

  scenario 'User finds a user by some text', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      check 'Users'
      fill_in 'Search text', with: user.email
      click_on 'Search'

      expect(page).to have_content user.email
    end
  end

  scenario 'Authenticated user finds a question by some text', js: true do
    log_in_user(user)
    visit root_path

    check 'Questions'
    fill_in 'Search text', with: question.title
    click_on 'Search'

    expect(page).to have_content question.title
  end

  scenario 'User finds everything by some text', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'Search text', with: 'find'
      click_on 'Search'

      expect(page).to have_content question.title
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
      expect(page).to have_content user.email
    end
  end

  scenario 'User finds nothing with non-exising match', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'Search text', with: 'Somethinghere'
      click_on 'Search'

      expect(page).to have_content 'Nothing found'
    end
  end
end