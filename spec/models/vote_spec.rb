require 'rails_helper'

RSpec.describe Vote, type: :model do
  it_behaves_like 'has_user'

  it { should belong_to(:votable) }

  it { should validate_uniqueness_of(:user_id).scoped_to(:votable_id, :votable_type) }
end
