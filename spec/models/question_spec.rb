require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'has_user'
  it_behaves_like 'attachable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe '#created_yesterday' do
    let!(:questions) { create_pair(:question) }
    let!(:old_questions) { create_list(:question, 2, created_at: 2.days.ago) }

    it 'returns questions of yesterday' do
      expect(Question.created_yesterday).to eq questions
    end

    it 'not returns old questions' do
      expect(Question.created_yesterday).to_not eq old_questions
    end
  end

  describe "Author of question can subscribe for question update's" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it "subscribes question's author" do
      expect { question.save }.to change(user.subscriptions, :count).by(1)
    end
  end
end
