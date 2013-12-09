class AddAttachmentPhotoToStudents < ActiveRecord::Migration
  def up
    change_table :students do |t|
      t.attachment :photo
    end
  end

  def down
    drop_attached_file :students, :photo
  end
end
