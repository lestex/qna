require 'rails_helper'

describe 'Question API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end
      it 'returns 401 status if no access_token' do
        get '/api/v1/questions', params: { format: :json, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

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
end