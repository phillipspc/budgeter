class CreatePlaidCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :plaid_categories do |t|
      t.references :category
      t.references :sub_category
      t.string :category_id
      t.text :hierarchy

      t.timestamps
    end
  end
end
