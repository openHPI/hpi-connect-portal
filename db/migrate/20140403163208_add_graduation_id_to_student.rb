class AddGraduationIdToStudent < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :graduation_id, :integer, null: false, default: 0
  end
end
