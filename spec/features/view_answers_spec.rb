require 'rails_helper'

feature 'User can answer a question' do
  given!(:question) { create(:question) }

  scenario 'User can view questions' 
end