class ChangeDataTypeForChairDescription < ActiveRecord::Migration
  def up
   change_column :chairs, :description, :text
  end

  def down
   change_column :chairs, :description, :string
  end
end
