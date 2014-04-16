class AddAcademicProgramIdToStudent < ActiveRecord::Migration
  def change
    add_column :students, :academic_program_id, :integer, null: false, default: 0
  end
end
