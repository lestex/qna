require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, [Question, Answer, Comment, Attachment, Vote] }    

    it { should be_able_to :set_email, User }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }
    it { should be_able_to :manage, :all}
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }    

    context 'create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    context 'update' do
      it { should be_able_to :update, create(:question, user: user) }
      it { should_not be_able_to :update, create(:question, user: other_user) }
      it { should be_able_to :update, create(:answer, user: user) }
      it { should_not be_able_to :update, create(:answer, user: other_user) }
    end

    context 'destroy' do
      it { should be_able_to :destroy, Question }
      it { should be_able_to :destroy, Answer }
      it { should be_able_to :destroy, Attachment }
    end

    context 'mark best' do
      it { should be_able_to :mark_best, create(:answer, question: question, user: question.user)}
      it { should_not be_able_to :mark_best, create(:answer, user: other_user) }
    end

    %i(vote_up vote_down vote_cancel).each do |action_performed| 
      context "can #{action_performed} against other users" do 
        it { should be_able_to action_performed, create(:question, user: other_user), user: user } 
        it { should be_able_to action_performed, create(:answer, user: other_user), user: user } 
      end 

      context "cannot #{action_performed} against self" do 
        it { should_not be_able_to action_performed, create(:question, user: user), user: user } 
        it { should_not be_able_to action_performed, create(:answer, user: user), user: user } 
      end 
    end

  end
end
