require 'plaid'

class PlaidItemsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_client

  def create
    begin
      # first perform the exchange to get our access_token
      exchange_token_response = @client.item.public_token.exchange(params[:public_token])
      access_token = exchange_token_response.access_token
      item_id = exchange_token_response.item_id

      institution_name = params[:metadata][:institution][:name]

      accounts_attributes, skipped = accounts_attributes_from_metadata(params[:metadata])

      plaid_item = PlaidItem.create!(user: @manager,
                                     access_token: access_token,
                                     item_id: item_id,
                                     name: institution_name,
                                     plaid_accounts_attributes: accounts_attributes)


      message = "Success"
      message = "One or more of the requested accounts was not saved because it has no " \
                "associated transactions." if skipped

      redirect_to root_path, notice: message
    rescue Plaid::PlaidAPIError => e
      redirect_to root_path, alert: e.inspect
    end
  end

  private

    def set_client
      @client = Plaid::Client.new(env: Rails.application.credentials.plaid_env,
                                  client_id: Rails.application.credentials.plaid_client_id,
                                  secret: Rails.application.credentials.plaid_secret,
                                  public_key: Rails.application.credentials.plaid_public_key)
    end

    def accounts_attributes_from_metadata(metadata)
      skipped = false
      attributes = metadata[:accounts].values.map do |val|
        if ["credit", "depository"].include?(val[:type])
          { account_id: val[:id], name: val[:name] }
        else
          skipped = true
          nil
        end
      end.compact

      [attributes, skipped]
    end
end
