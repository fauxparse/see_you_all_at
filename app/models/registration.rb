class Registration < ActiveRecord::Base
  belongs_to :user, inverse_of: :registrations
  belongs_to :event, inverse_of: :registrations
  belongs_to :package, inverse_of: :registrations

  scope :for_user, -> (user) { where(user: user) }

  validates :user, :event, :package, presence: true
end
