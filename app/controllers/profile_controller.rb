class ProfileController < ApplicationController
  before_action :set_user

  # GET /profile
  def show
    @user.generate_api_token! if @user.api_token.nil?
  end

  # PATCH /profile
  def update
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  # PATCH /profile/password
  def update_password
    if @user.authenticate(params[:current_password])
      if params[:password] == params[:password_confirmation]
        if @user.update(password: params[:password])
          redirect_to profile_path, notice: "Password updated successfully."
        else
          redirect_to profile_path, alert: "Failed to update password."
        end
      else
        redirect_to profile_path, alert: "New passwords do not match."
      end
    else
      redirect_to profile_path, alert: "Current password is incorrect."
    end
  end

  # POST /profile/reset_token
  def reset_token
    @user.reset_api_token!
    redirect_to profile_path, notice: "API token has been reset."
  end

  private

  def set_user
    @user = Current.session.user
  end

  def profile_params
    params.require(:user).permit(:email_address)
  end
end
