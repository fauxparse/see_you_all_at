class Package < ActiveRecord::Base
  include Sluggable

  belongs_to :event, inverse_of: :packages
  has_many :registrations, inverse_of: :package

  validates :name, :slug,
    uniqueness: { scope: :event_id, case_sensitive: false }
end
