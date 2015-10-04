class Identity < ActiveRecord::Base
  belongs_to :user, inverse_of: :identities

  belongs_to :user
  validates :uid, :provider,
    presence: { allow_blank: false }
  validates :uid,
    uniqueness: { scope: :provider }

  scope :oauth, -> (provider, uid) { where(provider: provider, uid: uid) }
end
