class Limit < ActiveRecord::Base
  belongs_to :package, inverse_of: :limits
  belongs_to :activity_type

  UNLIMITED = -1

  validates :maximum,
    presence: { allow_blank: false },
    numericality: { greater_than_or_equal_to: -1 }
end
