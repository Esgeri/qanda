require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }
  it { should accept_nested_attributes_for(:votes) }

  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:votable) { create(model.to_s.underscore.to_sym) }

  describe '#like_by' do
    it 'should set like votable' do
      votable.like_by(user)
      expect(Vote.last.is_liked).to be_truthy
    end

    it 'should increase rating' do
      votable.like_by(user)
      expect(votable.rating).to eq 1
    end
  end

  describe '#dislike_by' do
    it 'should set like votable' do
      votable.dislike_by(user)
      expect(Vote.last.is_liked).to be_falsy
    end

    it 'should decrease rating' do
      votable.dislike_by(user)
      expect(votable.rating).to eq -1
    end
  end

  describe '#unvote' do
    it 'should users unvote' do
      votable.dislike_by(user)
      expect { votable.unvote(user) }.to change(votable.votes, :count).by(-1)
    end
  end
end
