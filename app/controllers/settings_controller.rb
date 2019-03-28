class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_manager

  def edit
    @users = current_user.users.order("email")
  end
end
