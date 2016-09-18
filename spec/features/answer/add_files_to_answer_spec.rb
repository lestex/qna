require_relative '../features_helper'

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question)}
  given(:attachment) { create(:attachment, attachable: answer) }

  context 'authenticated user' do
    before do
      log_in_user(question.user)
      visit question_path(question)
      fill_in 'answer_body', with: 'Answer Title'
    end
    scenario 'adds one attachment when answers', js: true do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Answer a question'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end

    scenario 'adds few attachments when asks a question', js: true do
      click_link 'Add Attachment'
      inputs = page.all('input[type=file]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_button 'Answer a question'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/3/rails_helper.rb'
    end

    scenario 'deletes an attachment'
  end

  context 'regular user' do
    scenario 'user can see attachments of other users', js: true do
      answer.attachments << attachment
      log_in_user(question.user)
      visit question_path(question)
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
    scenario 'cnnot delete attchment of other user'
  end
end