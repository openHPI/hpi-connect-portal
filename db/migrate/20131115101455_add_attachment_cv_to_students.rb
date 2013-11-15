class AddAttachmentCvToStudents < ActiveRecord::Migration
  def self.up
    change_table :students do |t|
      t.attachment :cv
    end
  end

  def self.down
    drop_attached_file :students, :cv
  end
end
