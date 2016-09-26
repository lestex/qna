require 'rails_helper'

shared_examples_for 'has_user' do
  subject { create(described_class.to_s.underscore.to_sym) }
    context 'validates relationships' do
      it 'should belong to user' do
        expect(subject).to belong_to(:user)
      end
      it 'should have index for user' do
        expect(subject).to have_db_index(:user_id)
      end
    end

    it { expect(subject).to validate_presence_of(:user_id) }
 end