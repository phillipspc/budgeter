class AddPlaidTablesAndColumns < ActiveRecord::Migration[5.2]
  def change
    create_table :plaid_items do |t|
      t.references :user
      t.string :item_id
      t.string :access_token
      t.string :name

      t.timestamps
    end

    create_table :plaid_accounts do |t|
      t.references :plaid_item
      t.string :account_id
      t.string :name

      t.timestamps
    end

    create_table :ignored_transactions do |t|
      t.references :user
      t.string :plaid_transaction_id
      t.date :date

      t.timestamps
    end

    add_column :transactions, :plaid_transaction_id, :string
  end
end
