class AddEducationToStudents < ActiveRecord::Migration
  def change
    add_column :students, :education, :text
  end
end
