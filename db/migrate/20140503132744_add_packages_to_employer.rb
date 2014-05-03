class AddPackagesToEmployer < ActiveRecord::Migration
  def change
    add_column :employers, :requested_package, :integer, null: false, default: 0
    add_column :employers, :booked_package, :integer, null: false, default: 0
  end
end
