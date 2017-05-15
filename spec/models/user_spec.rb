require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:current_user) { create(:user) }
  let(:question) { create(:question, user: current_user) }
  let(:answer) { create(:answer, user: current_user, question: question) }
  let(:another_user) { create(:user) }
  let(:falsy_question) { create(:question) }
  let(:falsy_answer) { create(:answer) }

  describe 'author_of' do
    context 'compares the id of two objects, return true' do
      it 'should equal user id to question id' do
        expect(current_user).to be_author_of(question)
      end

      it 'should equal user id to answer id' do
        expect(current_user).to be_author_of(answer)
      end
    end

    context 'compares the id of two objects, return false' do
      it 'should not equal user id to question id' do
        expect(another_user).to_not be_author_of(falsy_question)
      end

      it 'should not equal user id to answer id' do
        expect(another_user).to_not be_author_of(falsy_answer)
      end
    end
  end
end
