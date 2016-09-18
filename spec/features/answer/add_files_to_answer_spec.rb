require_relative '../features_helper'

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question)}
  given(:attachment) { create(:attachment, attachable: answer) }

  scenario 'authenticated user adds one attachment when answers', js: true do
    log_in_user(question.user)
    visit question_path(question)
    fill_in 'answer_body', with: 'Answer Title'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Answer a question'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'authenticated user adds few attachments when asks a question', js: true do
    log_in_user(question.user)
    visit question_path(question)
    fill_in 'answer_body', with: 'Answer Title'
    click_link 'Add Attachment'
    inputs = page.all('input[type=file]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_button 'Answer a question'
    save_and_open_page
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/3/rails_helper.rb'
  end

  scenario 'user can see attachments of other users', js: true do
    answer.attachments << attachment
    log_in_user(question.user)
    visit question_path(question)
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end