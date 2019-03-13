class AddPlaidItems < ActiveRecord::Migration[5.2]
  def change
    create_table :plaid_items do |t|
      t.references :user
      t.string :item_id
      t.string :access_token
    end
  end
end
