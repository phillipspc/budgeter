require 'plaid'

class PlaidController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :get_access_token
  before_action :set_client, only: :get_access_token

  def link
  end

  def get_access_token
    exchange_token_response = @client.item.public_token.exchange(params['public_token'])
    access_token = exchange_token_response['access_token']
    p exchange_token_response

    render json: exchange_token_response.to_json
  end

  private

    def set_client
      @client = Plaid::Client.new(env: Rails.application.credentials.plaid_env,
                                  client_id: Rails.application.credentials.plaid_client_id,
                                  secret: Rails.application.credentials.plaid_secret,
                                  public_key: Rails.application.credentials.plaid_public_key)
    end
end
