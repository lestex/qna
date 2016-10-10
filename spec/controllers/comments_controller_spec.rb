require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:comment) { create(:comment) }

  describe 'POST #create for question' do
    before { sign_in(question.user) }
    context 'check valid conditions' do
      it 'creates a new comment with parameters' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :json }.to change(question.comments, :count).by(1)
      end
    end
    context 'check invalid conditions' do
      it 'fails with an incomplete comment' do
        expect { post :create, params: { question_id: question, comment: { body: '' } }, format: :json }.to_not change(question.comments, :count)
      end
    end
  end
  describe 'POST #create for answer' do
    before { sign_in(answer.user) }
    context 'check valid conditions' do
      it 'creates a new comment with parameters' do
        expect { post :create, params: { answer_id: answer, comment: attributes_for(:comment) }, format: :json }.to change(answer.comments, :count).by(1)
      end
    end
    context 'check invalid conditions' do
      it 'fails with an incomplete comment' do
        expect { post :create, params: { answer_id: answer, comment: { body: '' } }, format: :json }.to_not change(answer.comments, :count)
      end
    end
  end

end
