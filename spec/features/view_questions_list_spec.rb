require_relative 'features_helper'

feature 'View questions list', %q{
  In order to view a list of questions
  As a user
  I want to be able to see questions list
} do

  given!(:questions) { create_list(:question, 2) }
  scenario 'user can view all questions' do
    visit(questions_path)

    questions.each do |question|
      expect(page).to have_link(question.title)
      expect(page).to have_content question.title
    end
  end
end