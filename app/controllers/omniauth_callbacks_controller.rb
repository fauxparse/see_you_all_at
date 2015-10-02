class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  private

  def self.provides_callback_for(provider)
    class_eval %{
      def #{provider}
        service = FindUserForOauth.new(env["omniauth.auth"], current_user)
        @user = service.call.user

        if @user.persisted?
          sign_in_and_redirect(@user, event: :authentication)
          provider_success_message("#{provider}") if is_navigational_format?
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:twitter, :facebook, :google_oauth2].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end

  def provider_success_message(provider)
    set_flash_message(:notice, :success, kind: "#{provider}".capitalize)
  end
end
