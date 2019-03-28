class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_manager

  def edit
    @users = current_user.users.order("email")
  end

  def update
  end

  private

    def confirm_manager
      unless current_user.is_manager?
        redirect_to transactions_path, alert: "Only the account manager can edit account settings."
      end
    end
end
