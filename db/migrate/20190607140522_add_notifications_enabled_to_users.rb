class AddNotificationsEnabledToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notifications_enabled, :boolean, default: false
  end
end
