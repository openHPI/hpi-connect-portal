class AddAcademicProgramIdToStudent < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :academic_program_id, :integer, null: false, default: 0
  end
end
