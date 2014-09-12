class AddAttachmentCvAsPdfToStudents < ActiveRecord::Migration
  def self.up
    change_table :students do |t|
      t.attachment :cv_as_pdf
    end
  end

  def self.down
    drop_attached_file :students, :cv_as_pdf
  end
end
