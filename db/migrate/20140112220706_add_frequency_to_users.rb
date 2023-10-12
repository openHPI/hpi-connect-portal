class AddFrequencyToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :frequency, :integer, null: false, default: 1 
  end
end
