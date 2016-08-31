require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email}
  it { should validate_presence_of :password}

  it { should have_many :questions}
  it { should have_many :answers}

  describe '.owner_of?(resource)' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }

    it 'returns true if resource.user_id == self.id' do
      answer.user = user
      expect(user).to be_owner_of(answer)
    end

    it 'returns false if resource.user_id != self.id' do
      expect(user).not_to be_owner_of(answer)
    end
  end
end