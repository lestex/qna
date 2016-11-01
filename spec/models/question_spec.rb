require 'rails_helper'
require_relative 'concerns/has_user'
require_relative 'concerns/attachable'
require_relative 'concerns/votable'
require_relative 'concerns/commentable'

RSpec.describe Question, type: :model do 
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should validate_presence_of :title}
  it { should validate_presence_of :body}
 
  context 'concern checks' do
    it_behaves_like 'has_user'
    it_behaves_like 'attachable'
    it_behaves_like 'votable'
    it_behaves_like 'commentable'
  end

  context '#find_subscription' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:subscription) { create(:subscription, user_id: user.id) }
    let(:question) { create(:question, subscriptions: [subscription]) }

    it 'finds the subscription by the user' do
      expect(question.find_subscription(user).id).to be subscription.id
    end

    it 'cannot find the subscription from the user with no subscriptions' do
      expect(question.find_subscription(another_user)).to be_nil
    end
  end
end
