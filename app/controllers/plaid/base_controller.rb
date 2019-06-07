class Plaid::BaseController < ApplicationController
  before_action :ensure_plaid_access

  private
    def ensure_plaid_access
      unless @manager.has_plaid_access?
        redirect_to root_path, alert: "You do not have permission to access this page."
      end
    end

    def set_client
      # for admin only, use production Plaid client in development
      rails_env = user.email == Rails.application.credentials[Rails.env.to_sym][:admin_email] ? :production : Rails.env.to_sym

      @client = Plaid::Client.new(env: Rails.application.credentials[rails_env][:plaid_env],
                                  client_id: Rails.application.credentials[rails_env][:plaid_client_id],
                                  secret: Rails.application.credentials[rails_env][:plaid_secret],
                                  public_key: Rails.application.credentials[rails_env][:plaid_public_key])
    end
end
