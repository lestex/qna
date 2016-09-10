require 'rails_helper'

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
end
