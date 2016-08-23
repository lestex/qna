require 'rails_helper'

feature 'Viewing question list' do
  given!(:question) { create(:question) }

  scenario 'User can view questions' do
    visit questions_path
    
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end