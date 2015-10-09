class Event < ActiveRecord::Base
  has_many :administrators, inverse_of: :event, dependent: :destroy,
    autosave: true
  has_many :packages, inverse_of: :event, dependent: :destroy, autosave: true
  has_many :registrations, inverse_of: :event, dependent: :destroy
  has_many :activity_types, inverse_of: :event, dependent: :destroy,
    autosave: true

  before_validation :generate_slug, if: :name?
  before_validation :update_times

  validates :starts_on, :ends_on, :starts_at, :stops_at, :time_zone,
    presence: { allow_blank: false }
  validates :name, :slug, presence: { allow_blank: false }
  validates :slug, uniqueness: { case_sensitive: false }

  def to_param
    slug
  end

  def self.administered_by(user)
    joins(:administrators).where(administrators: { user_id: user.id })
  end

  private

  def generate_slug
    self.slug = name.to_url if slug.blank?
  end

  def update_times
    Time.use_zone(time_zone) do
      self.starts_at = starts_on.beginning_of_day if starts_on?
      self.stops_at = ends_on.beginning_of_day + 1.day if ends_on?
    end
  end
end
