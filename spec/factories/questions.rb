FactoryGirl.define do
  factory :question do
    sequence(:title) {  |n| "Question title#{n}" }
    sequence(:body) { |n| "Question body#{n}" }
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
