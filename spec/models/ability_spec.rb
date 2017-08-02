require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Attachment }
    it { should be_able_to :read, Vote }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:user_question) { create :question, user: user }
    let(:other_question) { create :question, user: other }

    let(:user_answer) { create :answer, question: user_question, user: user }
    let(:other_answer) { create :answer, question: user_question, user: other }
    let(:unacceptable_user_answer) { create :answer, question: other_question, user: user }
    let(:unacceptable_other_answer) { create :answer, question: other_question, user: other }

    let(:user_question_attachment) { create :attachment, attachable: user_question }
    let(:user_answer_attachment) { create :attachment, attachable: user_answer }
    let(:other_question_attachment) { create :attachment, attachable: other_question }
    let(:other_answer_attachment) { create :attachment, attachable: other_answer }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, create(:question, user: user), user: user }
      it { should_not be_able_to :update, create(:question, user: other), user: user }
      it { should be_able_to :destroy, create(:question, user: user) }
      it { should_not be_able_to :destroy, create(:question, user: other) }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, create(:answer, user: user), user: user }
      it { should_not be_able_to :update, create(:answer, user: other), user: user }
      it { should be_able_to :destroy, create(:answer, user: user) }
      it { should_not be_able_to :destroy, create(:answer, user: other) }
      it { should be_able_to :mark_best, user_answer }
      it { should be_able_to :mark_best, other_answer }
      it { should_not be_able_to :destroy, other_answer }
      it { should_not be_able_to :update, other_answer }
      it { should_not be_able_to :mark_best, unacceptable_user_answer }
      it { should_not be_able_to :mark_best, unacceptable_other_answer }
    end

    context 'Attachment' do
      it { should be_able_to :destroy, user_question_attachment }
      it { should be_able_to :destroy, user_answer_attachment }

      it { should_not be_able_to :destroy, other_question_attachment }
      it { should_not be_able_to :destroy, other_answer_attachment }
     end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end
  end
end
