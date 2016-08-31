require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create :question }

    context 'authenticated user creates answer' do
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

    context 'unauthenticated user creates answer' do
      it 'redirects to a login form' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'authenticated user deletes answer' do
      login_user
    end

    context 'unauthenticated user deletes answer' do
    end
  end
end
