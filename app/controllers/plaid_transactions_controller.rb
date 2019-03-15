class PlaidTransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client
  before_action :set_month

  def index
    @items = @manager.plaid_items.includes(:plaid_accounts)
    unless @items
      return redirect_to transactions_path, alert: "You have no accounts setup for importing transactions."
    end

    @items_and_transactions = transactions_for_items
  end

  private

    def set_client
      @client = Plaid::Client.new(env: Rails.application.credentials.plaid_env,
                                  client_id: Rails.application.credentials.plaid_client_id,
                                  secret: Rails.application.credentials.plaid_secret,
                                  public_key: Rails.application.credentials.plaid_public_key)
    end

    def transactions_for_items
      result = {}
      beginning_of_month = @month.to_date
      end_of_month = @month.to_date.end_of_month

      @items.each do |item|
        raise "Duplicate key" if result[item.name]
        result[item.name] = @client.transactions.
                              get(item.access_token, beginning_of_month, end_of_month)["transactions"]
      end
      result
    end
end
