class AddActivatedToEmployers < ActiveRecord::Migration[4.2]
  def change
    add_column :employers, :activated, :boolean, null: false, default: false
  end
end
