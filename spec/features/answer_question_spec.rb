require 'rails_helper'

feature 'User can answer a question' do
  given(:user) {create(:user)}
  context 'when signed in' do
    scenario 'User can answer a question'
  end

  context 'when not signed in' do
    scenario 'User redirected to a login form' 
  end
end