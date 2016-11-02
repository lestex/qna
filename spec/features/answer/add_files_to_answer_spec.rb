require_relative '../features_helper'

feature 'Add files to answer' do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question)}
  let!(:attachment) { create(:attachment, attachable: answer) }

  context 'authenticated user' do

    scenario 'adds few attachments when asks a question', js: true do
      log_in_user(question.user)
      visit question_path(question)
      fill_in 'answer_body', with: 'Answer Title'
      click_link 'Add Attachment'
      inputs = page.all('input[type=file]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_button 'Answer a question'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      #expect(page).to have_link 'rails_helper.rb'#, href: '/uploads/attachment/file/3/rails_helper.rb'
    end
  end
  scenario 'deletes an attachment', js: true do
    answer.attachments << attachment
    log_in_user(answer.user)
    visit question_path(question)
    within '.answers' do
      click_on 'Delete Attachment'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  context 'regular user' do
    scenario 'user can see attachments of other users', js: true do
      answer.attachments << attachment
      log_in_user(question.user)
      visit question_path(question)
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end

    scenario 'cannot delete an attachment of other user', js: true do
      answer.attachments << attachment
      log_in_user(user)
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link 'Remove Attachment'
      end
    end
  end
end