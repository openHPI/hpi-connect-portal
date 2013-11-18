class RenameColumnNameToLastnameForUsers < ActiveRecord::Migration
  def change
    rename_column :users, :name, :lastname
  end
end
