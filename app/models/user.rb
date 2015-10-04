class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = "change@me"
  TEMP_EMAIL_REGEX = /\Achange@me/

  has_many :identities, inverse_of: :user, dependent: :destroy
  has_many :administrators, inverse_of: :user, dependent: :destroy

  devise(
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :confirmable,
    :validatable,
    :omniauthable
  )

  validates :name,
    presence: { allow_blank: false }
  validates :email, on: :update,
    format: { without: TEMP_EMAIL_REGEX }

  def email_verified?
    email? && email !~ TEMP_EMAIL_REGEX
  end

  def requires_email_address?
    !email_verified? && !confirmation_sent_at?
  end
end
