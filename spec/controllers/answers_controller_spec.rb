require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create :question }

    login_user

    context 'with valid attributes' do
      it 'save new answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }}.to change(question.answers, :count).by(1)
      end
      it 'redirect to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer in database' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }}.to_not change(Answer, :count)
      end
      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template :show
      end
    end
  end
end
