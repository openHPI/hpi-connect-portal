class AddGroupIdToStudent < ActiveRecord::Migration
  def change
    add_column :students, :group_id, :integer, null: false, default: 0
  end
end
