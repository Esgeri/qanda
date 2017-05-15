require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:current_user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: current_user) }
  let(:answer) { create(:answer, user: current_user, question: question) }

  describe 'author_of' do
    context 'compares the id of two objects, return true' do
      it 'should equal user id to question id' do
        expect(current_user.author_of?(question)).to eq true
      end

      it 'should equal user id to answer id' do
        expect(current_user.author_of?(answer)).to eq true
      end
    end

    context 'compares the id of two objects, return false' do
      it 'should not equal user id to question id' do
        expect(another_user.author_of?(question)).to eq false
      end

      it 'should not equal user id to answer id' do
        expect(another_user.author_of?(answer)).to eq false
      end
    end
  end
end
