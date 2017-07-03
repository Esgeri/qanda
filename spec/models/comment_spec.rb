require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_behaves_like 'has_user'

  describe 'associations' do
    it { should belong_to :commentable }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end
end
