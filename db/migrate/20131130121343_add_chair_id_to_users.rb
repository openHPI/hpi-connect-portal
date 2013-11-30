class AddChairIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :chair_id, :integer
  end
end
