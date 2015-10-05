class Event < ActiveRecord::Base
  include Sluggable

  has_many :administrators, inverse_of: :event, dependent: :destroy,
    autosave: true
  has_many :packages, inverse_of: :event, dependent: :destroy, autosave: true

  before_validation :update_times

  validates :starts_on, :ends_on, :starts_at, :stops_at, :time_zone,
    presence: { allow_blank: false }
  validates :slug, uniqueness: { case_sensitive: false }

  def self.administered_by(user)
    joins(:administrators).where(administrators: { user_id: user.id })
  end

  private

  def update_times
    Time.use_zone(time_zone) do
      self.starts_at = starts_on.beginning_of_day if starts_on?
      self.stops_at = ends_on.beginning_of_day + 1.day if ends_on?
    end
  end
end
