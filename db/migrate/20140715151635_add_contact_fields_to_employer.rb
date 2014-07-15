class AddContactFieldsToEmployer < ActiveRecord::Migration
  def change
  	add_column :employers, :contact_name, :string
  	add_column :employers, :contact_street, :string
  	add_column :employers, :contact_zip_city, :string
  	add_column :employers, :contact_email, :string
  	add_column :employers, :contact_phone, :string
  end
end
