require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  describe 'POST #create' do
    before { sign_in(user) }
    it 'subscribes current user to the question' do
      expect { post :create, params: { question_id: question }, format: :js }.to change(question.subscriptions, :count).by(1)
    end
    before { post :create, params: { question_id: question }, format: :js }
    it 'creates a new subscription for current user' do
      expect(user.id).to eq assigns(:question).subscriptions.last.user_id
    end
    it 'renders show after creating a new question and subscrition' do
      expect(response).to render_template :create
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }
    context 'user removes his own subscription' do
      let(:subscription) { create(:subscription, user_id: user.id) }
      before { question.subscriptions << subscription }
      it 'unsubscribes the subscription from the question' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to change(question.subscriptions, :count).by(-1)
      end
      it 'renders show after creating a new question' do
        delete :destroy, params: { id: subscription }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "user tris to unsubscribe subscription he doesn't own" do
      let(:subscription) { create(:subscription) }
      before { question.subscriptions << subscription }
      it 'cannot unsubscribe the subscription of another user' do
          expect { delete :destroy, params: { id: subscription }, format: :js }.to_not change(question.subscriptions, :count)
      end
    end
  end
end