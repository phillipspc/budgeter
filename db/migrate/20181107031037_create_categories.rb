class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.references :user
      t.index [:user_id, :name], unique: true

      t.timestamps
    end

    create_table :sub_categories do |t|
      t.references :category
      t.string :name
      t.index [:category_id, :name], unique: true

      t.timestamps
    end
  end
end
