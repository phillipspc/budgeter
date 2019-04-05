class AddIncludeRecurringToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :include_recurring, :boolean, default: true
  end
end
