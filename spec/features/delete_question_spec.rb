require 'rails_helper'

feature 'delete a question' do
  given(:user) { create(:user_with_question) }
  given(:users_question_path) { "/questions/#{user.questions[0].id}" }
  given(:question) { create(:question) }
  given(:question_path) { "/questions/#{question.id}" }

  scenario 'user deletes a question he asked' do
    log_in_user(user)
    visit users_question_path    
    click_on 'Delete question'

    expect(page).not_to have_current_path(users_question_path)    
    expect(page).to have_content 'deleted successfully'    
  end

  scenario "user deletes a question he didn't asked" do
    log_in_user(user)
    visit question_path

    expect(page).to_not have_content 'delete question' 
  end
end