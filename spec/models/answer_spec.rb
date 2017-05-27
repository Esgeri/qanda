require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }

  describe 'best answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:best_answer) { create(:answer, best: true, question: question, user: user) }

    it 'mark best answer' do
      answer.set_best
      answer.reload
      expect(answer.best).to eq true
    end

    it 'change boolean value of best answer' do
      answer.set_best
      best_answer.reload
      expect(best_answer.best).to eq false
    end
  end
end
