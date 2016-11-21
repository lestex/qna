require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #show' do
    let(:question) { create(:question, body: 'some question body') }
    let(:answer) { create(:answer, body: 'some answer body') }
    let(:comment) { create(:comment, body: 'some comment body') }
    let(:user) { create(:user, email: 'some@example.com') }
    it 'finds everything' do
      expect(Search).to receive(:results).with(ActionController::Parameters.new(text: 'some'))
      xhr :get, :show, search: { text: 'some' }, format: :js
    end
  end
end