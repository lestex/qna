FactoryGirl.define do
  sequence :title do |n|
    "Question N #{n} title"
  end

  factory :question do
    title
    body "Question body"
    user

    factory :question_with_answers do
      transient do
        answers_count 2
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end
  
  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
