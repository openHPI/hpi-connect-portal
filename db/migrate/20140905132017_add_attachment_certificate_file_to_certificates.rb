class AddAttachmentCertificateFileToCertificates < ActiveRecord::Migration
  def self.up
    change_table :certificates do |t|
      t.attachment :certificate_file
    end
  end

  def self.down
    drop_attached_file :certificates, :certificate_file
  end
end
