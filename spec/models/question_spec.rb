require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'has_user'
  it_behaves_like 'attachable'

  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
