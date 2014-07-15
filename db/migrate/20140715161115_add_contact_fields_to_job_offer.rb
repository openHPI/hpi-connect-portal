class AddContactFieldsToJobOffer < ActiveRecord::Migration
  def change
  	add_column :job_offers, :contact_name, :string
  	add_column :job_offers, :contact_street, :string
  	add_column :job_offers, :contact_zip_city, :string
  	add_column :job_offers, :contact_email, :string
  	add_column :job_offers, :contact_phone, :string
  end
end
