class AddDschoolStatusIdToStudent < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :dschool_status_id, :integer, null: false, default: 0
  end
end
