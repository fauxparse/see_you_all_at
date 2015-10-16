class Activity < ActiveRecord::Base
  belongs_to :activity_type, inverse_of: :activities

  has_one :event, through: :activity_type

  acts_as_url :name,
    url_attribute: :slug,
    scope: :activity_type_id,
    sync_url: true

  validates :name, :activity_type_id, presence: { allow_blank: false }

  def to_param
    slug
  end
end
