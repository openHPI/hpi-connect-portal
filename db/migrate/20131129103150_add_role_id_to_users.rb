class AddRoleIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role_id, :integer, null: false, default: 1
  end
end
