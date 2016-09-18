require_relative '../features_helper'

feature 'Add files to question' do
  given!(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:attachment) { create(:attachment, attachable: question) }

  context 'authenticated user' do
    before do
      log_in_user(user)
      visit new_question_path
      fill_in 'Title', with: 'Test Title'
      fill_in 'Body', with: 'Question text'
    end

    scenario 'adds attachment when asks a question' do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create question'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end

    scenario 'adds more attachments when asks a question', js: true do
      click_link 'Add Attachment'
      inputs = page.all('input[type=file]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_on 'Create question'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/3/rails_helper.rb'
    end
  end

  scenario 'deletes an attachment', js: true do
    question.attachments << attachment
    log_in_user(question.user)
    visit question_path(question)
    within '.question-attachments' do
      click_on 'Delete Attachment'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  scenario 'user can see attachments of other users', js: true do
    question.attachments << attachment
    log_in_user(question.user)
    visit question_path(question)
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'user cannot delete attachments of other users', js: true do
    question.attachments << attachment
    log_in_user(user)
    visit question_path(question)
    within '.question-attachments' do
      expect(page).to_not have_link 'Remove Attachment'
    end
  end
end