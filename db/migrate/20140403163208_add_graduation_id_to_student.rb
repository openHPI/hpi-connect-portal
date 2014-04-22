class AddGraduationIdToStudent < ActiveRecord::Migration
  def change
    add_column :students, :graduation_id, :integer, null: false, default: 0
  end
end
