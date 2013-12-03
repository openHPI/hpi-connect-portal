class CreateStudentStatuses < ActiveRecord::Migration
  def change
    create_table :student_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
