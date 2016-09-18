require_relative '../features_helper'

feature 'Add files to question' do
  given!(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:attachment) { create(:attachment, attachable: question) }

  scenario 'authenticated user adds attachment when asks a question' do
    log_in_user(user)
    visit new_question_path
    fill_in 'Title', with: 'Test Title'
    fill_in 'Body', with: 'Question text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create question'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'authenticated user adds more attachments when asks a question', js: true do
    log_in_user(user)
    visit new_question_path
    fill_in 'Title', with: 'Test Title'
    fill_in 'Body', with: 'Question text'

    click_link 'Add Attachment'
    inputs = page.all('input[type=file]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Create question'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/3/rails_helper.rb'
  end

  scenario 'user can see attachments of other users', js: true do
    question.attachments << attachment
    log_in_user(question.user)
    visit question_path(question)
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end