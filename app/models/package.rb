class Package < ActiveRecord::Base
  include Sortable

  belongs_to :event, inverse_of: :packages
  has_many :registrations, inverse_of: :package

  acts_as_url :name,
    url_attribute: :slug,
    scope: :event_id,
    sync_url: true

  validates :name,
    presence: { allow_blank: false },
    uniqueness: { scope: :event_id, case_sensitive: false }

  def to_param
    slug
  end

  private

  def sortable_scope
    event.packages
  end
end
