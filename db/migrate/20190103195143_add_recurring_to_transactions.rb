class AddRecurringToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :recurring, :boolean, default: false
  end
end
