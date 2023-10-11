class ChangeHeadOfChairType < ActiveRecord::Migration[4.2]
  def change
  	change_column :chairs, :head_of_chair, :string, :null => false
  	add_index :chairs, :name, :unique => true
  end
end
