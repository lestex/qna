require 'rails_helper'

describe 'Question API' do
  describe 'GET /index' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }
      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns the right list of questions' do
        expect(response.body).to_not include_json(questions.count)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains the #{attr}" do
          question = questions.first
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }
      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains the #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      it_behaves_like 'API commentable'
      it_behaves_like 'API attachable'
      
    end
  end
  
  describe 'POST /create' do
    let(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        post '/api/v1/questions', params: { format: :json, question: attributes_for(:question) }
        expect(response.status).to eq 401
      end
      it 'returns 401 status if no access_token' do
        post '/api/v1/questions', params: { format: :json, access_token: '123456', question: attributes_for(:question) }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'creates a new question with parameters' do
        expect { post '/api/v1/questions', params: { format: :json, access_token: access_token.token, question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      before { post '/api/v1/questions', params: { format: :json, access_token: access_token.token, question: attributes_for(:question) } }
      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'has the right user assigned' do
        new_question = Question.last
        expect(new_question.user.id).to eq access_token.resource_owner_id
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains the #{attr}" do
          new_question = Question.last
          expect(response.body).to be_json_eql(new_question.send(attr.to_sym).to_json).at_path(attr)
        end
      end
    end
  end
  def do_request(params = {})
    get api_path, params: { format: :json }.merge(params)
  end
end