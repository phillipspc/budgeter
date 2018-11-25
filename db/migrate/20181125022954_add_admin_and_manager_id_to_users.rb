class AddAdminAndManagerIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_manager, :boolean, default: false
    add_column :users, :manager_id, :integer
  end
end
