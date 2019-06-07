class UsersController < ApplicationController
  before_action :confirm_manager

  def destroy
    user = current_user.users.find_by_id(params[:id])

    if user&.destroy
      redirect_to edit_settings_path, notice: "Successfully deleted User."
    else
      redirect_to edit_settings_path, alert: "Unable to delete User."
    end
  end
end
