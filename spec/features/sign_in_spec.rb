require 'rails_helper'

feature 'User sign in', %q{
  In order to ask question
  As an User
  Guest needs to be able to sign in
} do
  scenario 'Registered user tries to sign in' do
    User.create!(email: 'user@test.com', password: '123456')
    
  end

  scenario 'Unregistered user tries to sign in' do
  end
end