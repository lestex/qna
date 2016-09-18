require_relative '../features_helper'

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user adds when adds an answer', js: true do
    log_in_user(user)

    visit question_path(question)
    fill_in 'answer_body', with: 'Test Title'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Answer a question'
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end