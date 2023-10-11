class DropApplications < ActiveRecord::Migration[4.2]
  def change
  	drop_table :applications
  end
end
