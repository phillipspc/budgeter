class AddPlaidTransactionIdToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :plaid_transaction_id, :string
  end
end
