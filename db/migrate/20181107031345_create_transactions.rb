class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
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
