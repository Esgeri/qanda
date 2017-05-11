FactoryGirl.define do
  factory :question do
    sequence(:title) {  |n| "Question title#{n}" }
    sequence(:body) { |n| "Question body#{n}" }
    user

    trait :question_answers do
      answers { create_list(:answer, 5) }
    end
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
