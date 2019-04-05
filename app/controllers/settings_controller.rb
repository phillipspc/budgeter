class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_manager

  def edit
    @users = current_user.users.order("email")
  end

  def update
    current_user.update_attributes(include_recurring: params[:include_recurring])
    redirect_to params[:redirect_url]
  end
end
