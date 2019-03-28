class ApplicationController < ActionController::Base

  def authenticate_user!(opts = {})
    super

    @manager = current_user.is_manager? ? current_user : current_user.manager
  end

  def confirm_manager
    unless current_user.is_manager?
      redirect_to root_path, alert: "You do not have permission to take this action."
    end
  end

  def set_month
    @month = params[:month] || Time.now.strftime("%B %Y")
  end
end
