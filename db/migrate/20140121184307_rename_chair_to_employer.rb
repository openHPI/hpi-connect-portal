class RenameChairToEmployer < ActiveRecord::Migration[4.2]
  def change
  	rename_table :chairs, :employers
  	add_column :employers, :external, :boolean, :default => false
  end
end
