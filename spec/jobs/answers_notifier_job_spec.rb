require 'rails_helper'

RSpec.describe AnswersNotifierJob, type: :job do
  let(:question) { create(:question) }
  let(:subscriptions) { create_list(:subscription, 2, question: question) }
  let(:answer) { create(:answer, question: question) }

  it 'Users are notified by mail about a new reply' do
    answer.question.subscriptions.find_each do |subscription|
      expect(AnswerNotifierMailer).to receive(:notify).with(subscription.user, answer).and_call_original
    end
    AnswersNotifierJob.perform_now(answer)
  end
end
