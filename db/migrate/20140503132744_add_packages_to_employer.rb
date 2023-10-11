class AddPackagesToEmployer < ActiveRecord::Migration[4.2]
  def change
    add_column :employers, :requested_package_id, :integer, null: false, default: 0
    add_column :employers, :booked_package_id, :integer, null: false, default: 0
  end
end
