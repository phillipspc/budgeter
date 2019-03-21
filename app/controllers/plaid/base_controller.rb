class Plaid::BaseController < ApplicationController
  before_action :authenticate_user!
  
  private
    def set_client
      @client = Plaid::Client.new(env: Rails.application.credentials[Rails.env.to_sym][:plaid_env],
                                  client_id: Rails.application.credentials[Rails.env.to_sym][:plaid_client_id],
                                  secret: Rails.application.credentials[Rails.env.to_sym][:plaid_secret],
                                  public_key: Rails.application.credentials[Rails.env.to_sym][:plaid_public_key])
    end
end
