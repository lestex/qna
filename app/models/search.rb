class Search < ApplicationRecord
  def self.results(params)
    text = ThinkingSphinx::Query.escape params[:text]
    return results if text.blank?
    
    temp_hash = params.except(:text)
    classes = temp_hash.keys.each.map { |k| k.singularize.classify.constantize }
    ThinkingSphinx.search(text, classes: classes)
  end
end