class MoveFrequencyFromUsersToStudents < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :frequency, :integer, null: false, default: 1
    add_column :students, :frequency, :integer, null: false, default: 1
  end
end
