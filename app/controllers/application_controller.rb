class ApplicationController < ActionController::Base

  def authenticate_user!(opts = {})
    super

    @manager = current_user.is_manager? ? current_user : current_user.manager
    set_raven_context
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
