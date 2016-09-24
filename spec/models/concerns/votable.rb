require 'rails_helper'

shared_examples_for 'votable' do
  subject { create(described_class.to_s.underscore.to_sym) }
  
  it { should have_many(:votes) }
end