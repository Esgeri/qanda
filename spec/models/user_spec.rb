require 'rails_helper'

RSpec.describe User do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

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

  describe 'scope' do
    describe '#all_users_but_me' do
      it 'all_users_but_me' do
        users = create_list(:user, 3)
        me = users.first
        User.all_users_but_me(me).each do |user|
          expect(user).to_not eq me
        end
      end
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user has already authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }

    it 'should send daily digest to all users' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      User.send_daily_digest
    end
  end
end
