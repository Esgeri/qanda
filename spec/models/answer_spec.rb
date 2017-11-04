require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'has_user'
  it_behaves_like 'attachable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  describe 'associations' do
    it { should belong_to :question }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  describe 'best answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:best_answer) { create(:answer, best: true, question: question, user: user) }

    it 'mark best answer' do
      answer.set_best
      answer.reload
      expect(answer).to be_best
    end

    it 'change boolean value of best answer' do
      answer.set_best
      best_answer.reload
      expect(best_answer).to_not be_best
    end
  end

  describe 'Notification author of question after create answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }

    it 'notified job after create answer' do
      expect(AnswersNotifierJob).to receive(:perform_later).and_call_original
      answer.save!
    end

    it 'do not notified job after answer updated' do
      answer.save!
      expect(AnswersNotifierJob).to_not receive(:perform_later)
      answer.update!(body: 'answer updated!')
    end
  end
end
