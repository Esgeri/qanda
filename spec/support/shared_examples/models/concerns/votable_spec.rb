require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }
  it { should accept_nested_attributes_for(:votes) }

  let(:user) { create(:user) }
  let(:votable) { create(described_class.to_s.underscore.to_sym) }

  describe '#like_by' do
    it 'should set like to votable' do
      votable.like_by(user)
      expect(Vote.last.value).to eq 1
    end

    it 'should increase rating' do
      votable.like_by(user)
      expect(Vote.last.value).to eq 1
    end
  end

  describe '#dislike_by' do
    it 'should set dislike to votable' do
      votable.dislike_by(user)
      expect(Vote.last.value).to eq -1
    end

    it 'should decrease rating' do
      votable.dislike_by(user)
      expect(Vote.last.value).to eq -1
    end
  end

  describe '#unvote' do
    it 'should users unvote' do
      votable.dislike_by(user)
      expect { votable.unvote(user) }.to change(votable.votes, :count).by(-1)
    end
  end
end
