require 'rails_helper'

feature 'Delete a question' do
  given!(:question) { create(:question) }

  scenario 'User can delete a question' 
end