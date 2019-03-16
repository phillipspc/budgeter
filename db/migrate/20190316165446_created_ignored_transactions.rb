class CreatedIgnoredTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :ignored_transactions do |t|
      t.references :user
      t.string :plaid_transaction_id
      t.date :date

      t.timestamps
    end
  end
end
