FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Question answer#{n}" }
    association :question, factory: :question, title: "Тестовый вопрос", body: "Чему равно 2 * 2 ?"
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    association :question, factory: :question, title: "Тестовый вопрос", body: "Чему равно 2 * 2 ?"
  end
end
