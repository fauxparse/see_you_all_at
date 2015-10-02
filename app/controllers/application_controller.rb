class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def ensure_signup_complete
    return if action_name == "finish_signup"

    if current_user && current_user.requires_email_address?
      redirect_to finish_signup_path(current_user)
    end
  end
end
