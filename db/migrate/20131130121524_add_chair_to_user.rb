class AddChairToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :chair_id, :integer
  end
end
