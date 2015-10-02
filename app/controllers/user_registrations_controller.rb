class UserRegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(*permitted_fields)
  end

  def account_update_params
    params.require(:user).permit(:current_password, *permitted_fields)
  end

  def permitted_fields
    [:name, :email, :password, :password_confirmation]
  end
end
