require 'rails_helper'

shared_examples_for 'attachable' do
  subject { create(described_class.to_s.underscore.to_sym) }
  context 'validates relationships' do
    it 'should have many attachments' do
      expect(subject).to have_many(:attachments)
    end
  end
  it { expect(subject).to accept_nested_attributes_for(:attachments).allow_destroy(true) }
end