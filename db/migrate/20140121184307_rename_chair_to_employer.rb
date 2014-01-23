class RenameChairToEmployer < ActiveRecord::Migration
  def change
  	rename_table :chairs, :employers
  	add_column :employers, :external, :boolean, :default => false
  end
end
