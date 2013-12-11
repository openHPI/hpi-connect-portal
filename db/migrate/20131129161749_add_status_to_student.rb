class AddStatusToStudent < ActiveRecord::Migration
  def change
  	add_column :students, :status, :integer
  end
end
