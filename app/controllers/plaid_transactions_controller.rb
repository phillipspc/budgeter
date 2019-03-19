class PlaidTransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client, only: :index
  before_action :set_month, only: :index

  def index
    @items = @manager.plaid_items.includes(:plaid_accounts)
    unless @items
      return redirect_to transactions_path, alert: "You have no accounts setup for importing transactions."
    end

    @imported_ids = Transaction.includes(:user).by_month(@month).
                      where(user: @manager.group_users).
                      pluck(:plaid_transaction_id)
    @ignored_ids = IgnoredTransaction.by_month(@month).where(user: @manager.group_users).pluck(:plaid_transaction_id)
    @items_and_transactions = transactions_for_items
  end

  def new
    plaid_transaction = params[:plaid_transaction]
    @transaction = current_user.transactions.build(name: plaid_transaction[:name],
                                                   amount: plaid_transaction[:amount],
                                                   date: plaid_transaction[:date],
                                                   plaid_transaction_id: plaid_transaction[:transaction_id])

    category_query = plaid_transaction[:category].map do |category|
      "name ILIKE '%#{category}%'"
    end.join(" OR ")
    @category = @manager.categories.where(category_query).first
  end

  def create
    @transaction = current_user.transactions.build

    if @transaction.update_attributes(transaction_params)
      flash.now[:notice] = "Successfully saved Transaction."
    else @transaction.errors.any?
      flash.now[:alert] = @transaction.errors.full_messages.join(", ")
      render partial: 'application/flash_messages', formats: [:js]
    end
  end

  def edit
    @transaction = Transaction.where(plaid_transaction_id: params[:id], user: @manager.group_users).first
  end

  def update
    @transaction = Transaction.where(plaid_transaction_id: params[:id], user: @manager.group_users).first

    @transaction.update_attributes(transaction_params)
  end

  def destroy
    Transaction.where(plaid_transaction_id: params[:id], user: @manager.group_users).first.destroy
    @plaid_transaction_id = params[:id]
    flash.now[:notice] = "Successfully deleted Transaction"
  end

  private

    def transaction_params
      params.require(:transaction).permit(:plaid_transaction_id, :name, :amount, :category_id,
        :sub_category_id, :date)
    end

    def set_client
      @client = Plaid::Client.new(env: Rails.application.credentials[Rails.env.to_sym][:plaid_env],
                                  client_id: Rails.application.credentials[Rails.env.to_sym][:plaid_client_id],
                                  secret: Rails.application.credentials[Rails.env.to_sym][:plaid_secret],
                                  public_key: Rails.application.credentials[Rails.env.to_sym][:plaid_public_key])
    end

    def transactions_for_items
      result = {}
      beginning_of_month = @month.to_date
      end_of_month = @month.to_date.end_of_month

      @items.each do |item|
        account_ids_and_names = item.account_ids_and_names
        transactions = @client.transactions.
          get(item.access_token, beginning_of_month, end_of_month)["transactions"].
          map do |transaction|
            next unless account_ids_and_names.keys.include?(transaction["account_id"])
            transaction["account_name"] = account_ids_and_names[transaction["account_id"]]
            transaction["imported"] = @imported_ids.include?(transaction["transaction_id"])
            transaction["ignored"] = @ignored_ids.include?(transaction["transaction_id"])
            transaction
          end.compact

        result[item.id] = transactions
      end
      result
    end
end
