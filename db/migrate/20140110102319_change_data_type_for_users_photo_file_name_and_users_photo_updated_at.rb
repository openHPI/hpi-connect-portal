class ChangeDataTypeForUsersPhotoFileNameAndUsersPhotoUpdatedAt < ActiveRecord::Migration[4.2]
  def change
  	change_column :users, :photo_file_name, :string
  	change_column :users, :photo_updated_at, :timestamp
  end

  def self.up
    change_table :users do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :users, :photo
  end

end
