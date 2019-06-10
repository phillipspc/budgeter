class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_manager_and_raven_context


  def set_manager_and_raven_context
    if current_user
      @manager = current_user.is_manager? ? current_user : current_user.manager
      Raven.user_context(id: current_user.id)

      if current_user.email == Rails.application.credentials[Rails.env.to_sym][:admin_email]
        Rack::MiniProfiler.authorize_request
      end
    end

    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def confirm_manager
    unless current_user.is_manager?
      redirect_to root_path, alert: "Your account does not have the required permissions."
    end
  end

  def set_month
    @month = params[:month] || Time.current.strftime("%B %Y")
  end
end
