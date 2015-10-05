class Package < ActiveRecord::Base
  include Sluggable

  belongs_to :event, inverse_of: :packages

  validates :name, :slug,
    uniqueness: { scope: :event_id, case_sensitive: false }
end
