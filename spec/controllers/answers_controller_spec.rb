require 'rails_helper'
require_relative 'concerns/voted'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    context 'authenticated user creates answer' do
      login_user

      context 'with valid attributes' do
        it 'new answer belongs to user' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js}
                  .to change(@user.answers, :count).by(1)
        end
        it 'new answer belongs to user' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js}
                  .to change(question.answers, :count).by(1)
        end
        it 'saves the new answer in the database' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js}
                  .to change(Answer, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save answer in database' do
          expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }, format: :js}
                  .to_not change(Answer, :count)
        end
        it 'redirects to create template' do
          post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'unauthenticated user creates answer' do
      it 'does not save answer in database' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question }}.to_not change(Answer, :count)
        end
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
          expect{ delete :destroy, params: { question_id: question.id, id: answer.id }, format: :js}.to change(@user.answers, :count).by(-1)
        end

        it 'renders destroy template' do
          expect( delete :destroy, params: { question_id: question.id, id: answer.id }, format: :js ).to render_template :destroy
        end
      end
      context "he doesn't own" do
        it 'not deletes answer' do
          answer
          expect{ delete :destroy, params: { question_id: question.id, id: answer.id }, format: :js }.not_to change(Answer, :count)
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

  describe 'PATCH #update' do
    before { sign_in(answer.user) }
    context 'valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question}, format: :js
        expect(assigns(:answer)).to eq answer
      end
      before {patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question }, format: :js }
      it 'changes attributes for the answer' do
        answer.reload
        expect(answer.body).to eq 'new body'
      end
      it 'renders update template' do
        expect(response).to render_template :update
      end
    end
    context 'invalid attributes' do
      it 'does not change the answer' do
        patch :update, params: { id: answer, answer: { body: '' }, question_id: question }, format: :js
        expect(answer.body).to eq answer.body
      end
    end
  end

  describe 'PUT #mark_best' do
    context 'author of an answer' do
      let(:answer) { create(:answer, question: question, user: question.user) }
      before { sign_in(answer.user) }
      it 'marks it best' do
        put :mark_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to eq true
      end
      it 'renders best template' do
        put :mark_best, params: { id: answer }, format: :js
        answer.reload
        expect(response).to render_template 'answers/mark_best'
      end
    end

    context 'non-another conditions' do
      let(:user) { create(:user) }
      it 'does not change the best answer' do
        sign_in(user)
        put :mark_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to eq false
      end
    end

    describe 'CONCERN actions' do
      subject { create(:answer) }
      it_behaves_like 'voted'
    end
  end
end
