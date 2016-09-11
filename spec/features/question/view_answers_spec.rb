require_relative '../features_helper'

feature 'View question with answers' do
  given!(:question) { create(:question_with_answers) }

  scenario 'user can view answers for question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each do |answer|      
      expect(page).to have_content answer.body
    end
  end
end