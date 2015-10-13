class ActivityType < ActiveRecord::Base
  belongs_to :event, inverse_of: :activity_types
  has_many :limits, inverse_of: :activity_type, dependent: :destroy

  acts_as_list scope: :event, top_of_list: 0

  acts_as_url :plural,
    url_attribute: :slug,
    scope: :event_id,
    sync_url: true

  validates :name,
    presence: { allow_blank: false },
    uniqueness: { scope: :event_id, case_sensitive: false }

  def plural
    name.try(:pluralize)
  end

  def to_param
    slug
  end
end
