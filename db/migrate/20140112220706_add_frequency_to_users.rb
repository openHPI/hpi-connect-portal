class AddFrequencyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :frequency, :integer, null: false, default: 1
  end
end
