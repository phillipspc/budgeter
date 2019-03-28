class ApplicationController < ActionController::Base

  def authenticate_user!(opts = {})
    super

    @manager = current_user.is_manager? ? current_user : current_user.manager
  end

  def confirm_manager
    unless current_user.is_manager?
      redirect_to root_path, alert: "Your account does not have the required permissions."
    end
  end

  def set_month
    @month = params[:month] || Time.now.strftime("%B %Y")
  end
end
