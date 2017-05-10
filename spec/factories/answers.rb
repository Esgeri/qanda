FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Question answer#{n}" }
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
