require_relative 'features_helper'

module SphinxHelpers
  def index
    ThinkingSphinx::Test.index
    # Wait for Sphinx to finish loading in the new index files.
    sleep 0.25 until index_finished?
  end

  def index_finished?
    Dir[Rails.root.join(ThinkingSphinx::Test.config.indices_location, '*.{new,tmp}*')].empty?
  end
end

RSpec.configure do |config|
  config.include SphinxHelpers, type: :feature

  config.before(:each) do
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start
  end

  config.after(:each) do
    ThinkingSphinx::Test.stop
    ThinkingSphinx::Test.clear
  end
end