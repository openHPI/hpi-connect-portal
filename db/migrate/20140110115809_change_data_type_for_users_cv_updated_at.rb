class ChangeDataTypeForUsersCvUpdatedAt < ActiveRecord::Migration[4.2]
  def change
  	change_column :users, :cv_updated_at, :timestamp
  end

  def self.up
    change_table :users do |t|
      t.attachment :cv
    end
  end

  def self.down
    drop_attached_file :users, :cv
  end

end
