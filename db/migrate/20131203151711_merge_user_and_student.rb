class MergeUserAndStudent < ActiveRecord::Migration
  def change
    remove_column :students, :first_name
    remove_column :students, :last_name
    add_column :students, :user_id, :integer
  end
end
