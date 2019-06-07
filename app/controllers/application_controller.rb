class ApplicationController < ActionController::Base

  def authenticate_inviter!
    authenticate_user!(force: true)
  end

  def authenticate_user!(opts = {})
    super

    @manager = current_user.is_manager? ? current_user : current_user.manager
    set_raven_context
    # if current_user.email == Rails.application.credentials[Rails.env.to_sym][:admin_email]
    #   Rack::MiniProfiler.authorize_request
    # end
  end

  def confirm_manager
    unless current_user.is_manager?
      redirect_to root_path, alert: "Your account does not have the required permissions."
    end
  end

  def set_month
    @month = params[:month] || Time.current.strftime("%B %Y")
  end

  private

    def set_raven_context
      Raven.user_context(id: current_user.id)
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end
end
