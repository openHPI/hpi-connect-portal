class AddVisibilityIdToStudents < ActiveRecord::Migration
  def change
    add_column :students, :visibility_id, :integer, null: false, default: 0
  end
end
