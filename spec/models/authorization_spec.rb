require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it_behaves_like 'has_user'

  describe 'validations' do
    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
    it { should validate_uniqueness_of(:provider).scoped_to(:uid) }
  end
end
