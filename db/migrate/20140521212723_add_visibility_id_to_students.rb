class AddVisibilityIdToStudents < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :visibility_id, :integer, null: false, default: 0
  end
end
