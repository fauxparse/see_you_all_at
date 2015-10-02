class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user,
    only: [:show, :edit, :update, :destroy, :finish_signup]

  def index
  end

  def show
    # authorize! :read, @user
  end

  def edit
    # authorize! :update, @user
  end

  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, bypass: true)
        format.html { redirect_to @user, notice: t("profile.updated") }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def finish_signup
    # authorize! :update, @user
    update_user_after_signup if request.patch? && params[:user]
  end

  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    accessible = [:name, :email]
    accessible << password_params unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end

  def password_params
    [:password, :password_confirmation]
  end

  def update_user_after_signup
    if @user.update(user_params)
      @user.skip_reconfirmation!
      sign_in(@user, bypass: true)
      redirect_to @user, notice: "Your profile was successfully updated."
    else
      @show_errors = true
    end
  end
end
