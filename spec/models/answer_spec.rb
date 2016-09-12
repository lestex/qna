require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_db_index :user_id }
  it { should have_db_index :question_id }
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

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
    # it Нужен еще один тест: то, что старый лучший ответ стал не лучшим
    it 'sets previous best answer to false' do
      answer1.mark_best
      expect(answer2).to_not be_best
    end
  end
end
