class DropRoles < ActiveRecord::Migration
  def change
    drop_table :roles
  end
end
