class RenameColumnNameToLastnameForUsers < ActiveRecord::Migration[4.2]
  def change
    rename_column :users, :name, :lastname
  end
end
