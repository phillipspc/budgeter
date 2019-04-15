class AddHasPlaidAccessToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :has_plaid_access, :boolean, default: false
  end
end
