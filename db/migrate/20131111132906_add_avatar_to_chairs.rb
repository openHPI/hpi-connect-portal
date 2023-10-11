class AddAvatarToChairs < ActiveRecord::Migration[4.2]
  def up
    add_column :chairs, :avatar_file_name, :string
    add_column :chairs, :avatar_file_size, :integer
    add_column :chairs, :avatar_content_type, :string
    add_column :chairs, :avatar_updated_at, :datetime
  end

  def down 
    remove_column :chairs, :avatar_file_name, :string
    remove_column :chairs, :avatar_file_size, :integer
    remove_column :chairs, :avatar_content_type, :string
    remove_column :chairs, :avatar_updated_at, :datetime
  end
end
