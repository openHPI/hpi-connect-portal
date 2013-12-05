class ChangeDataTypeForChairDescription < ActiveRecord::Migration
  def self.up
   change_column :chairs, :description, :text
  end

  def self.down
   change_column :chairs, :description, :string
  end
end
