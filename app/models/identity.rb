class Identity < ActiveRecord::Base
  belongs_to :user, inverse_of: :identities

  belongs_to :user
  validates :uid, :provider,
    presence: { allow_blank: false}
  validates :uid,
    uniqueness: { scope: :provider }

  scope :oauth, -> (provider, uid) { where(provider: provider, uid: uid) }

  def self.find_for_oauth(auth)
    oauth(auth.provider, auth.uid).first_or_create!
  end
end
