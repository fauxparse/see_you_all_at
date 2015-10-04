class Administrator < ActiveRecord::Base
  belongs_to :event, inverse_of: :administrators
  belongs_to :user, inverse_of: :administrators

  validates :event, :user, presence: { allow_blank: false }
end
