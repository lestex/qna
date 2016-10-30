require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email}
  it { should validate_presence_of :password}

  it { should have_many :questions}
  it { should have_many :answers}
  it { should have_many(:votes) }
  it { should have_many(:authorizations) }

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  
  describe '#owner_of?(resource)' do
    it 'returns true if resource.user_id == self.id' do
      expect(question.user).to be_owner_of(question)
    end

    it 'returns false if resource.user_id != self.id' do
      expect(user).not_to be_owner_of(question)
    end
  end

  describe '#can_vote?' do
    it 'returns true if can vote for a question' do
      expect(user).to be_can_vote(question)
    end
    it 'returns false if cannot vote for a question' do
      question.votes.create(value: 1, user: question.user)
      expect(question.user).to_not be_can_vote(question)
    end
    it 'cannot vote for the question voted' do
      question.votes.create(value: 1, user: user)
      expect(user).to_not be_can_vote(question)
    end
  end

  describe '#can_cancel_vote?' do
    it 'cannot reject a vote which is not voted by the user' do
      expect(user).to_not be_can_cancel_vote(question)
    end
    it 'rejects a vote for the question voted' do
      question.votes.create(value: 1, user: user)
      expect(user).to be_can_cancel_vote(question)
    end
  end

  describe '#find_vote' do
    it 'finds a vote for the question' do
      vote = question.votes.create(value: 1, user: question.user)
      expect(vote.id).to be question.user.find_vote(question).id
    end
    it 'cannot find a vote for the question' do
      expect(nil).to be user.find_vote(question)
    end
  end

  describe '#voted?' do
    it 'checks the question was voted by another user' do
      question.votes.create(value: 1, user: user)
      expect(question.user).to_not be_voted(question)
    end
    it 'checks the question was voted' do
      question.votes.create(value: 1, user: question.user)
      expect(question.user).to be_voted(question)
    end
  end

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user does not have authorization' do
      context 'user already exists' do
        let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create a new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for the user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count)
        end

        it 'creates authorization with right provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'fake@mail.com' }) }

        it 'creates a new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        it 'returns a new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        it 'fills a user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to be_eql(auth.info.email)
        end
        it 'creates authorization for the user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end
        it 'creates authorization with right provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '.build_with_email' do
    it 'creates new user' do
      params = { user: { email: 'test@example.com' } }
      auth = { 'provider' => 'twitter', 'uid' => 123456,
               'user_password' => '123456' }
      expect { User.build_with_email(params, auth) }.to change(User, :count).by(1)
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }
    let(:questions) { create_list(:question, 2, user: users.first) }
    it 'sends the daily digest with latest questions created' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user, questions).and_call_original }
      User.send_daily_digest
    end
  end
end