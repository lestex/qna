require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    context 'authenticated user creates answer' do
      login_user

      context 'with valid attributes' do
        it 'new answer belongs to user' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question }}.to change(@user.answers, :count).by(1)
        end
        it 'saves the new answer in the database' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question }}.to change(Answer, :count).by(1)
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
          expect(response).to render_template 'questions/show'
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

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer, question: question) }

    context 'authenticated user deletes answer' do
      login_user
      context 'he owns' do
        it 'deletes answer' do
          answer.update(user_id: @user.id)
          expect{ delete :destroy, params: { question_id: question.id, id: answer.id } }.to change(@user.answers, :count).by(-1)
        end

        it 'redirects to question' do
          expect( delete :destroy, params: { question_id: question.id, id: answer.id } ).to redirect_to answer.question
        end
      end
      context "he doesn't own" do
        it 'not deletes answer' do
          answer
          expect{ delete :destroy, params: { question_id: question.id, id: answer.id } }.not_to change(Answer, :count)
        end

        it 'redirects to question' do
          expect( delete :destroy, params: { question_id: question.id, id: answer.id } ).to redirect_to answer.question
        end
      end
    end

    context 'unauthenticated user' do      
      it 'cant delete answer' do
        answer
        expect{ delete :destroy, params: { question_id: question.id, id: answer.id } }
            .not_to change(Answer, :count)
      end
      it 'redirects to login form' do
        expect( delete :destroy, params: { question_id: question.id, id: answer.id })
            .to redirect_to new_user_session_path
      end
    end
  end
end
