class FindUserForOauth
  attr_reader :auth

  def initialize(auth, signed_in_resource = nil)
    @auth = auth
    @signed_in_resource = signed_in_resource
    Rails.logger.info auth.inspect.green
  end

  def call
    associate_identity if identity.user != user
    self
  end

  def identity
    @identity ||= Identity.find_for_oauth(auth)
  end

  def user
    @user ||= @signed_in_resource ||
              identity.user ||
              user_from_email(auth.info.email)
  end

  private

  def user_from_email(email)
    email && find_user(email) || create_user(email)
  end

  def associate_identity
    identity.update!(user: user)
  end

  def find_user(email)
    User.find_by(email: email) if email
  end

  def create_user(email)
    new_user = User.new(
      name:     auth.extra.raw_info.name,
      email:    email || temporary_email,
      password: Devise.friendly_token[0, 20]
    )
    new_user.skip_confirmation!
    new_user.save!
    new_user
  end

  def temporary_email
    "#{User::TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
  end
end
