require 'rails_helper'

shared_examples_for 'searchable' do
  it 'finds all objects' do
    expect(objects.classify.constantize).to receive(:search).with(ThinkingSphinx::Query.escape(text))
    Search.results(text: text, objects.to_sym => true)
  end
end