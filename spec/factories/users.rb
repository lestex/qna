FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password '123456'
    password_confirmation '123456'

    factory :user_with_question do
      transient do
        questions_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:question, evaluator.questions_count, user: user)
      end
    end
  end
end
