require 'rails_helper'
require_relative 'concerns/has_user'
require_relative 'concerns/attachable'
require_relative 'concerns/votable'

RSpec.describe Question, type: :model do 
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :title}
  it { should validate_presence_of :body}
 
  context 'concern checks' do
    it_behaves_like 'has_user'
    it_behaves_like 'attachable'
    it_behaves_like 'votable'
  end
end
