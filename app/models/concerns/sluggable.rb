module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug, if: :name?

    validates :name, :slug, presence: { allow_blank: false }
  end

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = name.to_url if slug.blank?
  end
end
