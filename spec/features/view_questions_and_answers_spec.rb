require 'rails_helper'

feature 'Viewing questions and answers' do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'User can view questions' do
    visit questions_path

    expect(page).to have_content question.title
  end

  scenario 'User can view answers for question' do
    visit question_path(question)

    expect(page).to have_content answer.body
  end
end