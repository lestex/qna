require 'rails_helper'

shared_examples_for 'API attachable' do
  context 'attachments' do
    it 'included in the answer' do
      expect(response.body).to have_json_path('attachments')
    end

    it 'includes the url' do
      expect(response.body).to include_json((Rails.application.config.hostname_url + attachment.file.url).to_json).at_path('attachments/0/file_url')
    end

    %w(id created_at updated_at).each do |attr|
      it "contains the #{attr}" do
        expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
      end
    end
  end
end