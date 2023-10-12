class ChangeDataTypeForChairDescription < ActiveRecord::Migration[4.2]
  def up
   change_column :chairs, :description, :text
  end

  def down
   change_column :chairs, :description, :string
  end
end
