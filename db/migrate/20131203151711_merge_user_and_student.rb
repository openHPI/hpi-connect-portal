class MergeUserAndStudent < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :semester, :integer
    add_column :users, :academic_program, :string
    add_column :users, :birthday, :date
    add_column :users, :education, :text
    add_column :users, :additional_information, :text
    add_column :users, :homepage, :string
    add_column :users, :github, :string
    add_column :users, :facebook, :string
    add_column :users, :xing, :string
    add_column :users, :linkedin, :string
    add_column :users, :photo_file_name, :date
    add_column :users, :photo_content_type, :string
    add_column :users, :photo_file_size, :integer
    add_column :users, :photo_updated_at, :date
    add_column :users, :cv_file_name, :string
    add_column :users, :cv_content_type, :string
    add_column :users, :cv_file_size, :integer
    add_column :users, :cv_updated_at, :date
    add_column :users, :status, :integer
    add_column :users, :user_status_id, :integer
  end

  def self.up
    change_table :users do |t|
      t.attachment :cv
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :users, :cv
    drop_attached_file :users, :photo
  end
end
