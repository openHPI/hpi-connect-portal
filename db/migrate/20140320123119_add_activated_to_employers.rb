class AddActivatedToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :activated, :boolean, null: false, default: false
  end
end
