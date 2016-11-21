require 'rails_helper'

RSpec.describe Search, type: :model do
  
  describe '.search_for' do
    context 'search in questions' do
      let(:params) { { text: 'query', 'questions' => true } }

      it 'searching questions' do
        expect(ThinkingSphinx).to receive(:search).with('query', classes: [Question]).and_call_original
        Search.results(params)
      end
    end

    context 'search in answers' do
      let(:params) { { text: 'query', 'answers' => true } }

      it 'searching answers' do
        expect(ThinkingSphinx).to receive(:search).with('query', classes: [Answer]).and_call_original
        Search.results(params)
      end
    end

    context 'search in comments' do
      let(:params) { { text: 'query', 'comments' => true } }

      it 'searching comments' do
        expect(ThinkingSphinx).to receive(:search).with('query', classes: [Comment]).and_call_original
        Search.results(params)
      end
    end

    context 'search in users' do
      let(:params) { { text: 'query', 'users' => true } }

      it 'searching users' do
        expect(ThinkingSphinx).to receive(:search).with('query', classes: [User]).and_call_original
        Search.results(params)
      end
    end

    context 'search everywhere' do

      let(:params) { { text: 'query' } }

      it 'searching question with' do
        expect(ThinkingSphinx).to receive(:search).with('query', classes: []).and_call_original
        Search.results(params)
      end
    end

  end
end