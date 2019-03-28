class UsersController < ApplicationController
  before_action :authenticate_user!

  def destroy
    user = User.find(params[:id])

    unless current_user.is_manager? && current_user.users.include?(user)
      redirect_to transactions_path, notice: "You do not have permission to delete this User."
    end

    user.destroy
    redirect_to edit_settings_path, notice: "Successfully deleted User."
  end
end
