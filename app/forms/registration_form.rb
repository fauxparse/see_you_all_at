class RegistrationForm
  include Shout
  include Rails.application.routes.url_helpers

  attr_reader :registration, :event, :user

  delegate :errors, :valid, :package, to: :registration

  def initialize(user, event, params)
    @params = params.with_indifferent_access
    @event = event
    @user = user
    @registration = build_registration
  end

  def process!
    if @registration.persisted?
      publish!(:redirect, event)
    elsif @registration.valid?
      @registration.save!
      publish!(:render, "thanks")
    elsif @registration.package.blank?
      publish!(:render, "select_package")
    elsif @registration.package_changed?
      publish!(:redirect, registration_path)
    else
      publish!(:render, "new")
    end
  end

  def requires_authentication?
    @registration.user.blank? && @registration.package.present?
  end

  def package_slug
    (package || event.packages.first).to_param
  end

  def registration_path
    if package.present?
      event_package_registration_path(event, package)
    else
      event_registration_path(event)
    end
  end

  private

  def build_registration
    registration = event.registrations.for_user(user).first ||
                   event.registrations.build
    registration.attributes = params
    registration
  end

  def params
    slug = @params.delete(:package_slug)
    @params[:package_id] = package_with_slug(slug).try(:id) if slug
    @params[:package_id] ||= event.packages.first.id if single_package_event?
    @params[:user] = user
    @params
  end

  def package_with_slug(slug)
    event.packages.detect { |package| package.to_param == slug }
  end

  def single_package_event?
    event.packages.size == 1
  end

  def success_message
    I18n.t("registrations.success", event: event.name)
  end
end
