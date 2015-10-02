class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def ensure_signup_complete
    return if action_name == "finish_signup"
    redirect_to finish_signup_path(current_user) if awaiting_email_confirmation?
  end

  def awaiting_email_confirmation?
    current_user && current_user.requires_email_address?
  end
end
