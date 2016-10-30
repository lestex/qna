require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  describe 'POST #create' do
    before { sign_in(user) }
    it 'subscribes the current user to the question' do
      expect { post :create, params: { question_id: question }, format: :js }.to change(question.subscriptions, :count).by(1)
    end
    before { post :create, params: { question_id: question }, format: :js }
    it 'creates a new subscription as the current user' do
      expect(user.id).to eq assigns(:question).subscriptions.last.user_id
    end
    it 'renders show after creating a new question' do
      expect(response).to render_template :create
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }
    context 'subscription removes its own subscription' do
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

    context 'another user unsubscribes not its subscription' do
      let(:subscription) { create(:subscription) }
      before { question.subscriptions << subscription }
      it 'cannot unsubscribe the subscription from another user' do
          expect { delete :destroy, params: { id: subscription }, format: :js }.to_not change(question.subscriptions, :count)
      end
    end
  end
end