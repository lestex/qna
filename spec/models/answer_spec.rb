require 'rails_helper'
require_relative 'concerns/has_user'
require_relative 'concerns/attachable'
require_relative 'concerns/votable'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }

  it { should have_db_index :question_id }

  let(:question) { create(:question) }
  let!(:answer1) { create(:answer, question: question, best: false) }
  let!(:answer2) { create(:answer, question: question, best: true) }

  describe 'default_scope' do
    it 'sets best answer as first' do
      expect(Answer.first).to eq answer2
    end
  end

  context '.mark_best' do    
    it 'sets answer.best to true' do
      answer1.mark_best
      expect(answer1).to be_best
    end
    it 'sets previous best answer to false' do
      answer2.mark_best
      expect(answer1).to_not be_best
    end
  end

  context 'concern checks' do
    it_behaves_like 'has_user'
    it_behaves_like 'attachable'
    it_behaves_like 'votable'
  end

end
