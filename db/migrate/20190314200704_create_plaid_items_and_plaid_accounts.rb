class CreatePlaidItemsAndPlaidAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :plaid_items do |t|
      t.references :user
      t.string :item_id
      t.string :access_token
      t.string :name
    end

    create_table :plaid_accounts do |t|
      t.references :plaid_item
      t.string :account_id
      t.string :name
    end
  end
end
