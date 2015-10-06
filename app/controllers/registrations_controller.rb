class RegistrationsController < ApplicationController
  before_action :load_event
  before_action :build_registration_form, only: :register
  before_action :authenticate_user!, if: :authentication_required?

  wrap_parameters :registration, include: [:package_id, :package_slug]

  def register
    @registration_form
      .on(:render)   { |*args| render(*args) }
      .on(:redirect) { |*args| clear_stored_location_and_redirect_to(*args) }
      .process!
  end

  private

  def event_scope
    super.includes(:packages)
  end

  def build_registration_form
    @registration_form = RegistrationForm.new(
      current_user,
      @event,
      registration_params
    )
  end

  def registration_params
    if params[:registration].present?
      params.require(:registration).permit(:package_id, :package_slug)
    else
      { package_slug: params[:package_slug] }
    end
  end

  def authentication_required?
    if @registration_form
      store_location_for(:user, @registration_form.registration_path)
      @registration_form.requires_authentication?
    else
      true
    end
  end

  def clear_stored_location_and_redirect_to(*args)
    session.delete(stored_location_key_for(:user))
    redirect_to(*args)
  end
end
