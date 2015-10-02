class UsersController < ApplicationController
  require_power_check
  power :users, as: :users

  before_action :authenticate_user!
  before_action :set_user,
    only: [:show, :edit, :update, :destroy, :finish_signup]

  def index
    @users = users.all
  end

  def show
    current_power.user!(@user)
  end

  def edit
    current_power.updatable_user!(@user)
  end

  def update
    current_power.updatable_user!(@user)

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
    current_power.updatable_user!(@user)
    update_user_after_signup if request.patch? && params[:user]
  end

  def destroy
    current_power.destroyable_user!(@user)
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
