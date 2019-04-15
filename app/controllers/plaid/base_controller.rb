class Plaid::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_plaid_access

  private
    def ensure_plaid_access
      unless @manager.has_plaid_access?
        redirect_to root_path, alert: "You do not have permission to access this page."
      end
    end

    def set_client
      @client = Plaid::Client.new(env: Rails.application.credentials[Rails.env.to_sym][:plaid_env],
                                  client_id: Rails.application.credentials[Rails.env.to_sym][:plaid_client_id],
                                  secret: Rails.application.credentials[Rails.env.to_sym][:plaid_secret],
                                  public_key: Rails.application.credentials[Rails.env.to_sym][:plaid_public_key])
    end
end
