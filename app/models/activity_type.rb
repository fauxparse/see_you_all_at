class ActivityType < ActiveRecord::Base
  include Sortable

  belongs_to :event, inverse_of: :activity_types

  acts_as_url :plural,
    url_attribute: :slug,
    scope: :event_id,
    sync_url: true

  validates :name,
    presence: { allow_blank: false },
    uniqueness: { scope: :event_id }

  def plural
    name.pluralize
  end

  private

  def sortable_scope
    event.activity_types
  end
end
