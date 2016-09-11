require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_db_index :user_id }
  it { should have_db_index :question_id }
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  describe 'default_scope' do
    let!(:answer) { create(:answer) }
    let!(:answer2) { create(:answer) }

    it 'best answer should be first' do
      answer2.update(best: true)
      expect(Answer.all).to eq [answer2, answer]
    end
  end

  context '.mark_best' do
    let(:question) { create(:question) }
    before { create(:answer, question: question) }
    it 'sets answer.best to trues' do
      question.answers.first.mark_best
      expect(question.answers.first.best).to be true
    end
  end
end
