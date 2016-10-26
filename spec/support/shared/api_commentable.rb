require 'rails_helper'

shared_examples_for 'API commentable' do
  context 'comments' do
    it 'included in the answer' do
      expect(response.body).to have_json_path('comments')
    end

    %w(id body created_at updated_at).each do |attr|
      it "contains the #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
      end
    end
  end
end