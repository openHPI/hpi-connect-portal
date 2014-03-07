class ChangeEmploymentStatusToIdForStudents < ActiveRecord::Migration
  def change
    remove_column :students, :employment_status, :string
    add_column :students, :employment_status_id, :integer, null: false, default: 0
  end
end
