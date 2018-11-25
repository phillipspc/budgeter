class ApplicationController < ActionController::Base

  def authenticate_user!
    super

    @manager = current_user.is_manager? ? current_user : current_user.manager
  end
end
