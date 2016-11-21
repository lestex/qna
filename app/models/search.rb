class Search < ApplicationRecord
  def self.results(search_params)
    results = []
    text = ThinkingSphinx::Query.escape search_params[:text]
    return results if text.blank?
    
    %w(questions answers comments users).each do |filter|
      results += filter.classify.constantize.search(text).to_a if search_params[filter.to_sym]
    end
    results = ThinkingSphinx.search(text, classes: [Question, Answer, Comment, User]) if results.blank?
    results
  end
end