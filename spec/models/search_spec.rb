require 'rails_helper'
require_relative 'concerns/searchable'

RSpec.describe Search, type: :model do
  let(:question) { create(:question, body: 'some body to find') }
  let(:answer) { create(:answer, body: 'some body to find') }
  let(:comment) { create(:comment, body: 'some body to find') }
  let(:user) { create(:user, email: 'some@mail.ru') }
  context 'questions' do
    let(:objects) { 'questions' }
    let(:text) { question.body }
    it_behaves_like 'searchable'
  end
  context 'answers' do
    let(:objects) { 'answers' }
    let(:text) { answer.body }
    it_behaves_like 'searchable'
  end
  context 'answers' do
    let(:objects) { 'comments' }
    let(:text) { comment.body }
    it_behaves_like 'searchable'
  end
  context 'answers' do
    let(:objects) { 'users' }
    let(:text) { 'some@mail.ru' }
    it_behaves_like 'searchable'
  end
  it 'finds everything' do
    expect(ThinkingSphinx).to receive(:search).with('some', { classes: [Question, Answer, Comment, User] })
    Search.results(text: 'some')
  end

  it 'does not receive search with empty search' do
    expect(ThinkingSphinx).to_not receive(:search)
    Search.results(text: '')
  end

  it 'returns nothing with empty search' do
    results = Search.results(text: '')
    expect(results).to be_empty
  end

  it 'returns nothing with search not containing anything' do
    results = Search.results(text: 'somethinghere')
    expect(results).to be_empty
  end
end