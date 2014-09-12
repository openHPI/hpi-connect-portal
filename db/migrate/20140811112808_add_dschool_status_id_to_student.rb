class AddDschoolStatusIdToStudent < ActiveRecord::Migration
  def change
    add_column :students, :dschool_status_id, :integer, null: false, default: 0
  end
end
