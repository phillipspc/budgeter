class InitialMigration < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_manager, :boolean, default: false
    add_column :users, :manager_id, :integer

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
      t.decimal :budget

      t.timestamps
    end

    create_table :transactions do |t|
      t.references :user
      t.references :category
      t.references :sub_category
      t.string :name
      t.decimal :amount
      t.date :date

      t.timestamps
    end
  end
end
