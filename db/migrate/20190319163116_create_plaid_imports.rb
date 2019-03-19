class CreatePlaidImports < ActiveRecord::Migration[5.2]
  def change
    create_table :plaid_imports do |t|
      t.references :user
      t.string :plaid_item_id
      t.jsonb :data
      t.string :month

      t.timestamps
    end
  end
end
