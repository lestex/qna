require 'rails_helper'

feature 'Question list' do
  given!(:questions) { create_list(:question, 2) }
  scenario 'user can see all the questions' do
    visit(questions_path)

    questions.each do |question|
      expect(page).to have_link(question.title)
    end
  end
end