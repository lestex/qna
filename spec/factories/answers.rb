FactoryGirl.define do
  factory :answer do
    body "Answer to a question"
    question
    user   
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question   
  end
end
