class Authorization < ApplicationRecord
  include HasUser

  validates :provider, :uid, presence: true
  validates :provider, uniqueness: { scope: :uid }
end
