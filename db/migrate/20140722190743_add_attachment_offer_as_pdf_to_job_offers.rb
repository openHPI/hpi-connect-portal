class AddAttachmentOfferAsPdfToJobOffers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :job_offers, :offer_as_pdf_file_name, :string
    add_column :job_offers, :offer_as_pdf_file_size, :integer
    add_column :job_offers, :offer_as_pdf_content_type, :string
    add_column :job_offers, :offer_as_pdf_updated_at, :datetime
  end

  def self.down
    remove_column :job_offers, :offer_as_pdf_file_name, :string
    remove_column :job_offers, :offer_as_pdf_file_size, :integer
    remove_column :job_offers, :offer_as_pdf_content_type, :string
    remove_column :job_offers, :offer_as_pdf_updated_at, :datetime
  end
end
