class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_manager

  def edit
    @users = current_user.users.order("email")
  end

  def update
    current_user.update_attributes(settings_params)
    redirect_to params[:redirect_url]
  end

  private

    def settings_params
      params.permit(:include_recurring, :notifications_enabled)
    end
end
