class AddAttachmentCvToStudents < ActiveRecord::Migration
  def up
    change_table :students do |t|
      t.attachment :cv
    end
  end

  def down
    drop_attached_file :students, :cv
  end
end
