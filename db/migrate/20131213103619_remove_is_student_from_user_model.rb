class RemoveIsStudentFromUserModel < ActiveRecord::Migration
  def change
    remove_column :users, :is_student
  end
end
