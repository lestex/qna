require 'rails_helper'

feature 'delete an answer' do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers) }
  given(:other_users_answer) { question.answers.first }

  scenario 'authenticated user deletes his answer' do
    log_in_user(user)
    visit question_path(question)
    fill_in 'answer_body', with: 'User answer'
    click_on 'Answer a question'
    save_and_open_page
    expect(page).to have_content('User answer')    
    expect(page).to have_link('Delete answer', 
        href: question_answer_path(question, user.answers.last.id))
    expect(page)
      .not_to have_link('Delete answer',
        href: question_answer_path(question, other_users_answer))
    click_on 'Delete answer'

    expect(page).to have_current_path(question_path(question))
    expect(page).to have_content 'Answer has been deleted'
    expect(page).not_to have_content 'User answer'
    expect(page).not_to have_link 'Delete answer'
  end

  scenario 'unauthenticated user tries to delete his answer' do
    visit question_path(question)
    
    expect(page).to_not have_link('Delete answer')
  end
end