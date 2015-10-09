class Package < ActiveRecord::Base
  include Sluggable
  include Sortable

  belongs_to :event, inverse_of: :packages
  has_many :registrations, inverse_of: :package

  validates :name, :slug,
    uniqueness: { scope: :event_id, case_sensitive: false }

  private

  def sortable_scope
    event.packages
  end
end
