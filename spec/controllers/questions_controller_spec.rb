require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:question_with_answers) { create(:question_with_answers) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'it populates an array of questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do    
    before { get :show, params: { id: question_with_answers } }
    
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question_with_answers      
    end

    it 'assigns a new attachment for an @answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns answers for a question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe 'GET #new' do
    context 'authenticated user' do
      login_user
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'build a new Attachment for @question' do
        expect(assigns(:question).attachments.first).to be_a_new(Attachment)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'unauthenticated user' do
      before { get :new, params: {}}

      it 'redirects to a login form' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do
    login_user
    before { get :edit, params: { id: question } }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do

    context 'authenticated user creates a question' do
      login_user

      context 'with valid attributes' do
        it 'new question belongs to user' do 
          expect { post :create, params: {question: attributes_for(:question) }}.to change(@user.questions, :count).by(1)
        end
        it 'saves the new question in the database' do
          expect { post :create, params: {question: attributes_for(:question) }}.to change(Question, :count).by(1)
        end
        it 'redirects to show view' do
          post :create, params: {question: attributes_for(:question)}
          expect(response).to redirect_to assigns(:question)
          expect(flash[:success]).to match 'question created successfully'          
        end
      end

      context 'with valid attributes' do
        it 'redirects to new question' do
          post :create, params: { question: attributes_for(:invalid_question) }
          expect(response).to render_template :new
        end
        it 'question not saved in the database' do
          expect { post :create, params: { question: attributes_for(:invalid_question) } }
            .to_not change(Question, :count)
        end
      end
    end
    context 'unauthenticated user creates a question' do
      it 'cant create' do
        expect { post :create, params: { question: attributes_for(:question) }}
          .not_to change(Question, :count)        
      end
      it 'redirects to login url' do        
        expect(post :create, params: { question: attributes_for(:question) })
          .to redirect_to new_user_session_path        
      end
    end
  end

  describe 'PATCH #update' do
    login_user
    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question)}, format: :js
        expect(assigns(:question)).to eq question
      end

      before do
        question.update(user: @user)
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }}, format: :js 
      end
      it 'changes attributes for the question' do
        question.reload
        expect(question.title).to eq 'new title'
      end
      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      it 'does not change the question' do
        patch :update, params: { id: question, question: attributes_for(:invalid_question) }, format: :js
        expect(question).to eq question
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user deletes a question' do
      login_user
      context 'he owns' do
        before { question.update(user_id: @user.id) }
        it 'deletes question' do
          expect { delete :destroy, params: { id: question} }.to change(Question, :count).by(-1)
        end
        
        it 'redirects to show view' do
          delete :destroy, params: { id: question}
          expect(response).to redirect_to assigns(:question)
        end
      end
    end

    context "he doesn't own" do
      before { question }
      it 'does not delete question' do
        expect { delete :destroy, params: { id: question} }.to_not change(Question, :count)
      end
    end

    context 'unauthenticated user deletes a question' do
      it 'cant delete' do
        question
        expect { delete :destroy, params: { id: question} }.to_not change(Question, :count)
      end
      it 'redirects to login form' do
        expect( delete :destroy, params: { id: question})
            .to redirect_to new_user_session_path
      end
    end
  end
end
