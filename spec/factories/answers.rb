FactoryGirl.define do
  factory :answer do
    body "Answer to a question"
    question   
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question   
  end
end
