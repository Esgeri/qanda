FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Question answer#{n}" }
    best false
    association :question, factory: :question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    association :question, factory: :question
  end
end
