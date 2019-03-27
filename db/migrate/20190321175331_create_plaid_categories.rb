class CreatePlaidCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :plaid_categories do |t|
      t.text :hierarchy
      t.references :category
      t.references :sub_category
      t.string :plaid_category_id

      t.timestamps
    end
  end
end
