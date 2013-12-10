class AddStudentStatusIdToStudent < ActiveRecord::Migration
  def change
    add_column :students, :student_status_id, :integer
  end
end
