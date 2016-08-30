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

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns answers for a question' do
      create_list(:answer, 5)
      expect(assigns(:answers)).to eq question_with_answers.answers
    end
  end

  describe 'GET #new' do
    context 'authenticated user' do
      login_user
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
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
        it 'saves new question in the database' do 
          expect { post :create, params: {question: attributes_for(:question) }}.to change(Question, :count).by(1)
        end
        it 'redirects to show view' do
          post :create, params: {question: attributes_for(:question)}
          expect(response).to redirect_to assigns(:question)
          should set_flash[:success].to 'question created successfully'
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
      it 'redirects to login url and show errors' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
        should set_flash[:alert].to 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe 'PATCH #update' do
    login_user
    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: {id: question, question: attributes_for(:question)}
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        patch :update, params: {id: question, question: {title: 'new title', body: 'new body'}}
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 'redirects to the updated question' do
        patch :update, params: {id: question, question: attributes_for(:question)}
        expect(response).to redirect_to question
      end 
    end

    context 'invalid attributes' do
      before { patch :update, params: {id: question, question: {title: 'new title', body: nil}} }
      it 'does not change question attributes' do        
        question.reload
        expect(question.title).to eq 'Question title'
        expect(question.body).to eq 'Question body'
      end
      it 're-renders edit view' do
        expect(response).to render_template :edit
      end 
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user deletes a question' do
      login_user
      context 'user deletes own qestion' do
        let(:user_questions) { @user.questions }
        before { delete :destroy, params: { id: user_questions[0] } }
        
        it { should redirect_to(root_path) }
        it { should set_flash[:success].to(t('flash.danger.destroy_question')) }
      end
    end

    context 'unauthenticated user deletes a question' do
    end
  end
end
