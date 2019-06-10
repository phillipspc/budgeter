class IgnoredTransactionsController < ApplicationController
  def create
    @plaid_transaction_id = params[:plaid_transaction_id]
    @manager.ignored_transactions.create(plaid_transaction_id: @plaid_transaction_id, date: params[:date])
  end

  def destroy
    @plaid_transaction_id = params[:id]
    ignored_transaction = @manager.ignored_transactions.find_by_plaid_transaction_id(params[:id])
    ignored_transaction.destroy
  end
end
