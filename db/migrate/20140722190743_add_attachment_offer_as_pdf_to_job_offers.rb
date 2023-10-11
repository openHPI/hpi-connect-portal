class AddAttachmentOfferAsPdfToJobOffers < ActiveRecord::Migration[4.2]
  def self.up
    change_table :job_offers do |t|
      t.attachment :offer_as_pdf
    end
  end

  def self.down
    drop_attached_file :job_offers, :offer_as_pdf
  end
end
