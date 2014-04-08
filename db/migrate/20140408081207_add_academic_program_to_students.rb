class AddAcademicProgramToStudents < ActiveRecord::Migration
  def change
    add_column :students, :academic_program, :string
  end
end
