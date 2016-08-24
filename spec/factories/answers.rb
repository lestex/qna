FactoryGirl.define do
  factory :answer do
    body "Answer to a question"    
  end

  factory :invalid_answer, class: 'Answer' do
    body nil    
  end
end
