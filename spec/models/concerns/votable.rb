require 'rails_helper'

shared_examples_for 'votable' do
  subject { create(described_class.to_s.underscore.to_sym) }

  let(:user) { create(:user) }
  describe '.vote_rating' do
    it 'gets vote rating' do
      subject.votes.create(value: 1, user: subject.user)
      subject.votes.create(value: 1, user: subject.user)
      subject.votes.create(value: -1, user: subject.user)
      expect(subject.vote_rating).to eq(1)
    end
  end
  
  it { should have_many(:votes) }
end