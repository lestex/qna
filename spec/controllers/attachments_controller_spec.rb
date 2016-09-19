require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:attachment) { create(:attachment, attachable: question) }

  describe 'DELETE #destroy' do
    before { sign_in(question.user) }
    it 'removes an attachment' do
      expect { delete :destroy, params: { id: attachment }, format: :js }.to change(Attachment, :count).by(-1)
    end
    it 'renders destroy template' do
      delete :destroy, params: { id: attachment }, format: :js
      expect(response).to render_template 'attachments/destroy'
    end
  end
  context 'remove an attachment created by another user' do
    it 'cannot remove an attachment' do
      sign_in(user)
      expect { delete :destroy, params: { id: attachment }, format: :js }.to_not change(Attachment, :count)
    end
  end
end
